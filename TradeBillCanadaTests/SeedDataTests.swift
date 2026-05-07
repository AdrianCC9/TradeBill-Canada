import SwiftData
import XCTest
@testable import TradeBillCanada

@MainActor
final class SeedDataTests: XCTestCase {
    func testEnsureDefaultsCreatesSettingsAndPurchaseStateOnce() throws {
        let container = ModelContainerFactory.makePreviewContainer()
        let context = container.mainContext

        SeedData.ensureDefaults(in: context)
        SeedData.ensureDefaults(in: context)

        let settings = try context.fetch(FetchDescriptor<AppSettings>())
        let purchaseStates = try context.fetch(FetchDescriptor<PurchaseState>())

        XCTAssertEqual(settings.count, 1)
        XCTAssertEqual(purchaseStates.count, 1)
        XCTAssertEqual(settings.first?.nextInvoiceNumber, 1)
        XCTAssertEqual(settings.first?.freeDocumentsCreated, 0)
        XCTAssertEqual(purchaseStates.first?.hasLifetimeUnlock, false)
    }
}
