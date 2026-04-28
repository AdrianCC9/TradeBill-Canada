import SwiftData
import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Query private var settings: [AppSettings]
    @Query private var purchaseStates: [PurchaseState]

    private var priceText: String {
        purchaseManager.lifetimeProduct?.displayPrice ?? "Loading price…"
    }

    private var canPurchase: Bool {
        purchaseManager.lifetimeProduct != nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                Spacer()

                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(AppTheme.turquoise)

                VStack(spacing: 10) {
                    Text("Unlock unlimited invoices and estimates.")
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    Text("One-time purchase. No subscription. No account required.")
                        .font(.body)
                        .foregroundStyle(AppTheme.mutedText)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 12) {
                    PrimaryButton(title: "\(priceText) Lifetime", systemImage: "lock.open") {
                        Task {
                            await purchaseManager.purchaseLifetimeUnlock()
                            persistUnlockIfNeeded()
                            if purchaseManager.hasLifetimeUnlock { dismiss() }
                        }
                    }
                    .disabled(!canPurchase)
                    .opacity(canPurchase ? 1 : 0.65)

                    SecondaryButton(title: "Restore Purchase", systemImage: "arrow.clockwise") {
                        Task {
                            await purchaseManager.restorePurchases()
                            persistUnlockIfNeeded()
                            if purchaseManager.hasLifetimeUnlock { dismiss() }
                        }
                    }

                    Button("Maybe Later") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.mutedText)
                }

                if let message = purchaseManager.lastErrorMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.errorRed)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding(24)
            .background(AppTheme.offWhite.ignoresSafeArea())
            .navigationTitle("Lifetime Unlock")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await purchaseManager.loadProducts()
            }
        }
    }

    private func persistUnlockIfNeeded() {
        guard purchaseManager.hasLifetimeUnlock else { return }
        let appSettings = settings.first ?? AppSettings()
        if settings.isEmpty { modelContext.insert(appSettings) }
        appSettings.hasLifetimeUnlock = true

        let purchaseState = purchaseStates.first ?? PurchaseState()
        if purchaseStates.isEmpty { modelContext.insert(purchaseState) }
        purchaseState.hasLifetimeUnlock = true
        purchaseState.lastVerifiedAt = .now
        try? modelContext.save()
    }
}
