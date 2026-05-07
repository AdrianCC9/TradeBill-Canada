import XCTest
@testable import TradeBillCanada

final class DocumentNumberServiceTests: XCTestCase {
    func testInvoiceAndEstimateNumbersUseIndependentPrefixesAndCounters() {
        let settings = AppSettings(nextInvoiceNumber: 12, nextEstimateNumber: 3)

        XCTAssertEqual(DocumentNumberService.nextNumber(for: .invoice, settings: settings), "INV-0012")
        XCTAssertEqual(DocumentNumberService.nextNumber(for: .estimate, settings: settings), "EST-0003")
    }

    func testConsumingNumberOnlyAdvancesMatchingCounter() {
        let settings = AppSettings(nextInvoiceNumber: 12, nextEstimateNumber: 3)

        DocumentNumberService.consumeNextNumber(for: .invoice, settings: settings)

        XCTAssertEqual(settings.nextInvoiceNumber, 13)
        XCTAssertEqual(settings.nextEstimateNumber, 3)
    }

    func testCorruptedZeroOrNegativeCountersRecoverToOneThenAdvance() {
        let settings = AppSettings(nextInvoiceNumber: 0, nextEstimateNumber: -4)

        XCTAssertEqual(DocumentNumberService.nextNumber(for: .invoice, settings: settings), "INV-0001")
        XCTAssertEqual(DocumentNumberService.nextNumber(for: .estimate, settings: settings), "EST-0001")

        DocumentNumberService.consumeNextNumber(for: .invoice, settings: settings)
        DocumentNumberService.consumeNextNumber(for: .estimate, settings: settings)

        XCTAssertEqual(settings.nextInvoiceNumber, 2)
        XCTAssertEqual(settings.nextEstimateNumber, 2)
    }
}
