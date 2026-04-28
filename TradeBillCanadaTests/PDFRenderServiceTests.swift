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
}
