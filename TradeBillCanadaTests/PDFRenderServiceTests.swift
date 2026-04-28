import PDFKit
import XCTest
@testable import TradeBillCanada

final class PDFRenderServiceTests: XCTestCase {
    func testRenderProducesPDFData() {
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: [
                    CalculationLineItem(description: "Window cleaning", quantity: 2, unitPrice: 85)
                ],
                discountType: .none,
                discountValue: 0,
                taxPreset: TaxPresetService.preset(matchingProvinceCode: CanadianProvince.ON.code),
                amountPaid: 0
            )
        )
        let request = PDFRenderRequest(
            businessName: "TradeBill Test Co.",
            businessContactLines: ["Toronto, ON", "test@example.com"],
            documentType: .invoice,
            documentNumber: "INV-0007",
            issueDate: Date(timeIntervalSinceReferenceDate: 1_000_000),
            dueDate: Date(timeIntervalSinceReferenceDate: 1_086_400),
            clientLines: ["Jane Client", "jane@example.com"],
            title: "Spring service",
            lineItems: [
                CalculationLineItem(description: "Window cleaning", quantity: 2, unitPrice: 85)
            ],
            totals: totals,
            notes: "Thank you.",
            terms: "Due on receipt."
        )

        let data = PDFRenderService.render(request: request)

        XCTAssertGreaterThan(data.count, 1_000)
        XCTAssertEqual(String(data: Data(data.prefix(4)), encoding: .ascii), "%PDF")
    }

    func testRequestMakeHonoursCustomDocumentTax() {
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0008",
            title: "Custom tax job",
            taxProvinceCode: nil,
            taxLabel: "Local Levy 7.25%",
            taxRatePercent: 7.25
        )
        document.lineItems = [
            LineItem(itemDescription: "Service", quantity: 1, unitPriceCents: 10_000, sortOrder: 0, document: document)
        ]

        let request = PDFRenderRequest.make(document: document, businessProfile: nil)

        XCTAssertEqual(request.totals.taxLines.map(\.label), ["Local Levy"])
        XCTAssertEqual(request.totals.taxAmount, Decimal(string: "7.25"))
        XCTAssertEqual(request.totals.total, Decimal(string: "107.25"))
    }

    func testRenderIncludesAllLineItemsAcrossMultiplePages() {
        let lineItems = (1...30).map { index in
            CalculationLineItem(description: "Service line \(index)", quantity: 1, unitPrice: 10)
        }
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: lineItems,
                discountType: .none,
                discountValue: 0,
                taxPreset: TaxPresetService.noTax,
                amountPaid: 0
            )
        )
        let request = PDFRenderRequest(
            businessName: "TradeBill Test Co.",
            businessContactLines: ["Toronto, ON", "test@example.com"],
            documentType: .invoice,
            documentNumber: "INV-0030",
            issueDate: Date(timeIntervalSinceReferenceDate: 1_000_000),
            dueDate: Date(timeIntervalSinceReferenceDate: 1_086_400),
            clientLines: ["Jane Client", "jane@example.com"],
            title: "Large job",
            lineItems: lineItems,
            totals: totals,
            notes: "Thank you.",
            terms: "Due on receipt."
        )

        let data = PDFRenderService.render(request: request)
        let document = PDFDocument(data: data)
        let extractedText = (0..<(document?.pageCount ?? 0))
            .compactMap { document?.page(at: $0)?.string }
            .joined(separator: "\n")

        XCTAssertGreaterThanOrEqual(document?.pageCount ?? 0, 3)
        XCTAssertTrue(extractedText.contains("Service line 1"))
        XCTAssertTrue(extractedText.contains("Service line 30"))
        XCTAssertTrue(extractedText.contains("Summary"))
    }

    func testRenderIncludesInvoicePaidAmountInTotals() {
        let lineItems = [
            CalculationLineItem(description: "Deposit job", quantity: 1, unitPrice: 300)
        ]
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: lineItems,
                discountType: .none,
                discountValue: 0,
                taxPreset: TaxPresetService.preset(for: .ON),
                amountPaid: 150
            )
        )
        let request = PDFRenderRequest(
            businessName: "TradeBill Test Co.",
            businessContactLines: ["Toronto, ON", "test@example.com"],
            documentType: .invoice,
            documentNumber: "INV-0010",
            issueDate: Date(timeIntervalSinceReferenceDate: 1_000_000),
            dueDate: Date(timeIntervalSinceReferenceDate: 1_086_400),
            clientLines: ["Jane Client"],
            title: "Deposit job",
            lineItems: lineItems,
            totals: totals,
            amountPaid: 150,
            notes: "",
            terms: ""
        )

        let data = PDFRenderService.render(request: request)
        let document = PDFDocument(data: data)
        let extractedText = document?.page(at: 0)?.string ?? ""

        XCTAssertTrue(extractedText.contains("Paid"))
        XCTAssertTrue(extractedText.contains("-$150.00"))
        XCTAssertTrue(extractedText.contains("Balance Due"))
    }
}
