import XCTest
@testable import TradeBillCanada

final class EntitlementGateTests: XCTestCase {
    func testFreeUserCanCreateUpToThreeDocuments() {
        let settings = AppSettings(freeDocumentsCreated: 2, hasLifetimeUnlock: false)

        XCTAssertTrue(EntitlementGate.canCreateDocument(settings: settings, purchaseState: nil))
    }

    func testFreeUserIsBlockedAfterThreeDocuments() {
        let settings = AppSettings(freeDocumentsCreated: 3, hasLifetimeUnlock: false)

        XCTAssertFalse(EntitlementGate.canCreateDocument(settings: settings, purchaseState: nil))
    }

    func testLifetimeUnlockAllowsCreationAfterFreeLimit() {
        let settings = AppSettings(freeDocumentsCreated: 3, hasLifetimeUnlock: true)

        XCTAssertTrue(EntitlementGate.canCreateDocument(settings: settings, purchaseState: nil))
    }
}

