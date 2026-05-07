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

    func testPDFPageCountsAtPaginationBoundaries() {
        XCTAssertEqual(renderedPageCount(lineItemCount: 6), 1)
        XCTAssertEqual(renderedPageCount(lineItemCount: 7), 2)
        XCTAssertEqual(renderedPageCount(lineItemCount: 15), 2)
        XCTAssertEqual(renderedPageCount(lineItemCount: 16), 3)
        XCTAssertEqual(renderedPageCount(lineItemCount: 39), 3)
        XCTAssertEqual(renderedPageCount(lineItemCount: 40), 4)
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

    func testRequestMakeCapsOverpaidAmountAtDocumentTotal() {
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0011",
            taxProvinceCode: nil,
            taxLabel: "No tax",
            taxRatePercent: 0,
            amountPaidCents: 50_000,
            totalCents: 10_000
        )
        document.lineItems = [
            LineItem(itemDescription: "Service", quantity: 1, unitPriceCents: 10_000, sortOrder: 0, document: document)
        ]

        let request = PDFRenderRequest.make(document: document, businessProfile: nil)

        XCTAssertEqual(request.amountPaid, Decimal(100))
        XCTAssertEqual(request.totals.balanceDue, Decimal.zero)
    }

    func testRequestMakeTrimsBusinessClientAndFooterFields() {
        let profile = BusinessProfile(
            businessName: "  TradeBill Test Co.  ",
            ownerName: "  Jane Owner  ",
            email: " owner@example.com ",
            phone: " 555-0199 ",
            addressLine1: " 44 King St ",
            city: " Toronto ",
            provinceCode: " ON ",
            postalCode: " M5V 1A1 ",
            taxNumber: " 123456789RT0001 "
        )
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0012",
            title: "  Trimmed title  ",
            notes: "  Notes  ",
            terms: "  Terms  "
        )
        document.clientNameSnapshot = " Jane Client "
        document.clientCompanySnapshot = " Jane Co. "
        document.clientEmailSnapshot = " jane@example.com "
        document.clientPhoneSnapshot = " 555-0100 "
        document.clientAddressSnapshot = " 123 Main, Toronto "

        let request = PDFRenderRequest.make(document: document, businessProfile: profile)

        XCTAssertEqual(request.businessName, "TradeBill Test Co.")
        XCTAssertEqual(request.businessContactLines, [
            "Jane Owner",
            "44 King St, Toronto, ON, M5V 1A1",
            "555-0199",
            "owner@example.com",
            "Tax #: 123456789RT0001"
        ])
        XCTAssertEqual(request.clientLines, [
            "Jane Client",
            "Jane Co.",
            "123 Main, Toronto",
            "jane@example.com",
            "555-0100"
        ])
        XCTAssertEqual(request.title, "Trimmed title")
        XCTAssertEqual(request.notes, "Notes")
        XCTAssertEqual(request.terms, "Terms")
    }

    private func renderedPageCount(lineItemCount: Int) -> Int {
        let lineItems = (1...lineItemCount).map { index in
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
            documentNumber: "INV-\(lineItemCount)",
            issueDate: Date(timeIntervalSinceReferenceDate: 1_000_000),
            dueDate: Date(timeIntervalSinceReferenceDate: 1_086_400),
            clientLines: ["Jane Client"],
            title: "Boundary job",
            lineItems: lineItems,
            totals: totals,
            notes: "",
            terms: ""
        )

        return PDFDocument(data: PDFRenderService.render(request: request))?.pageCount ?? 0
    }
}
