import XCTest
@testable import TradeBillCanada

final class EntitlementGateTests: XCTestCase {
    func testFreeUserCanCreateUpToThreeDocuments() {
        let settings = AppSettings(freeDocumentsCreated: 2, hasLifetimeUnlock: false)

        XCTAssertTrue(EntitlementGate.canCreateDocument(settings: settings, purchaseState: nil))
    }

    func testMissingSettingsStartsInsideFreeLimit() {
        XCTAssertTrue(EntitlementGate.canCreateDocument(settings: nil, purchaseState: nil))
    }

    func testFreeUserIsBlockedAfterThreeDocuments() {
        let settings = AppSettings(freeDocumentsCreated: 3, hasLifetimeUnlock: false)

        XCTAssertFalse(EntitlementGate.canCreateDocument(settings: settings, purchaseState: nil))
    }

    func testLifetimeUnlockAllowsCreationAfterFreeLimit() {
        let settings = AppSettings(freeDocumentsCreated: 3, hasLifetimeUnlock: true)

        XCTAssertTrue(EntitlementGate.canCreateDocument(settings: settings, purchaseState: nil))
    }

    func testPersistedPurchaseStateAllowsCreationAfterFreeLimit() {
        let settings = AppSettings(freeDocumentsCreated: 3, hasLifetimeUnlock: false)
        let purchaseState = PurchaseState(hasLifetimeUnlock: true)

        XCTAssertTrue(EntitlementGate.canCreateDocument(settings: settings, purchaseState: purchaseState))
    }

    func testPDFExportIsBlockedAfterFreeLimitWithoutUnlock() {
        let settings = AppSettings(freeDocumentsCreated: 3, hasLifetimeUnlock: false)

        XCTAssertFalse(EntitlementGate.canExportPDF(settings: settings, purchaseState: nil))
    }

    func testPurchaseStateUnlockWorksEvenWhenSettingsAreMissing() {
        XCTAssertTrue(
            EntitlementGate.canCreateDocument(
                settings: nil,
                purchaseState: PurchaseState(hasLifetimeUnlock: true)
            )
        )
    }
}
