import XCTest
@testable import TradeBillCanada

final class DocumentConversionServiceTests: XCTestCase {
    func testEstimateConversionCreatesInvoiceAndConsumesInvoiceNumber() {
        let issueDate = Date(timeIntervalSinceReferenceDate: 1_000_000)
        let estimate = Document(
            type: .estimate,
            documentNumber: "EST-0004",
            title: "Deck repair",
            issueDate: issueDate,
            dueDate: issueDate,
            statusRawValue: EstimateStatus.accepted.rawValue,
            subtotalCents: 50_000,
            discountType: .fixed,
            discountValueCents: 2_500,
            taxProvinceCode: CanadianProvince.ON.code,
            taxLabel: "HST 13%",
            taxRatePercent: 13,
            taxAmountCents: 6_175,
            totalCents: 53_675,
            balanceDueCents: 53_675,
            notes: "Original estimate notes.",
            terms: "Due on receipt."
        )
        estimate.clientNameSnapshot = "Jane Client"
        estimate.clientEmailSnapshot = "jane@example.com"
        estimate.lineItems = [
            LineItem(itemDescription: "Materials", quantity: 1, unitPriceCents: 20_000, sortOrder: 1, document: estimate),
            LineItem(itemDescription: "Labour", quantity: 3, unitPriceCents: 10_000, sortOrder: 0, document: estimate)
        ]
        let settings = AppSettings(nextInvoiceNumber: 7, freeDocumentsCreated: 2)

        let invoice = DocumentConversionService.makeInvoice(
            from: estimate,
            settings: settings,
            issueDate: issueDate
        )

        XCTAssertEqual(invoice.type, .invoice)
        XCTAssertEqual(invoice.documentNumber, "INV-0007")
        XCTAssertEqual(invoice.statusRawValue, InvoiceStatus.unpaid.rawValue)
        XCTAssertEqual(invoice.convertedFromEstimateId, estimate.id)
        XCTAssertEqual(invoice.clientNameSnapshot, "Jane Client")
        XCTAssertEqual(invoice.clientEmailSnapshot, "jane@example.com")
        XCTAssertEqual(invoice.totalCents, estimate.totalCents)
        XCTAssertEqual(invoice.balanceDueCents, estimate.totalCents)
        XCTAssertEqual(invoice.amountPaidCents, 0)
        XCTAssertEqual(invoice.sortedLineItems.map(\.itemDescription), ["Labour", "Materials"])
        XCTAssertTrue(invoice.sortedLineItems.allSatisfy { $0.document === invoice })
        XCTAssertEqual(estimate.statusRawValue, EstimateStatus.converted.rawValue)
        XCTAssertEqual(settings.nextInvoiceNumber, 8)
        XCTAssertEqual(settings.freeDocumentsCreated, 3)
    }
}
