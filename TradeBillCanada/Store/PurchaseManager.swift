import Combine
import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var hasLifetimeUnlock = false
    @Published var lastErrorMessage: String?

    var lifetimeProduct: Product? {
        products.first { $0.id == ProductIDs.lifetimeUnlock }
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: [ProductIDs.lifetimeUnlock])
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    func purchaseLifetimeUnlock() async {
        do {
            guard let product = lifetimeProduct else {
                throw StoreError.productUnavailable
            }

            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                try await apply(verification)
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    func refreshEntitlements() async {
        var unlocked = false
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try verified(result)
                if transaction.productID == ProductIDs.lifetimeUnlock {
                    unlocked = true
                }
            } catch {
                lastErrorMessage = error.localizedDescription
            }
        }
        hasLifetimeUnlock = unlocked
    }

    private func apply(_ result: VerificationResult<Transaction>) async throws {
        let transaction = try verified(result)
        if transaction.productID == ProductIDs.lifetimeUnlock {
            hasLifetimeUnlock = true
        }
        await transaction.finish()
    }

    private func verified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}
