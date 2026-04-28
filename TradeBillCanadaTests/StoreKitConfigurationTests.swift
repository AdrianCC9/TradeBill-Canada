import StoreKit
import StoreKitTest
import XCTest
@testable import TradeBillCanada

final class StoreKitConfigurationTests: XCTestCase {
    @MainActor
    func testLocalStoreKitConfigurationLoadsLifetimeProduct() async throws {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Configuration.storekit")
        let session = try SKTestSession(contentsOf: url)
        session.disableDialogs = true
        session.clearTransactions()

        let products = try await Product.products(for: [ProductIDs.lifetimeUnlock])

        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.id, ProductIDs.lifetimeUnlock)
        XCTAssertEqual(products.first?.type, .nonConsumable)
    }
}
