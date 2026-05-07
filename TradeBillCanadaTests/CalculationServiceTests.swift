import XCTest
@testable import TradeBillCanada

final class CalculationServiceTests: XCTestCase {
    func testOntarioInvoiceWithFixedDiscountAndDeposit() {
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: [
                    CalculationLineItem(description: "A", quantity: 1, unitPrice: 300),
                    CalculationLineItem(description: "B", quantity: 1, unitPrice: 280),
                    CalculationLineItem(description: "C", quantity: 1, unitPrice: 96)
                ],
                discountType: .fixed,
                discountValue: 50,
                taxPreset: TaxPresetService.preset(for: .ON),
                amountPaid: 150
            )
        )

        XCTAssertEqual(totals.subtotal, Decimal(string: "676.00")!)
        XCTAssertEqual(totals.discountAmount, Decimal(string: "50.00")!)
        XCTAssertEqual(totals.taxableAmount, Decimal(string: "626.00")!)
        XCTAssertEqual(totals.taxAmount, Decimal(string: "81.38")!)
        XCTAssertEqual(totals.total, Decimal(string: "707.38")!)
        XCTAssertEqual(totals.balanceDue, Decimal(string: "557.38")!)
    }

    func testBritishColumbiaPercentageDiscount() {
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: [
                    CalculationLineItem(description: "A", quantity: 1, unitPrice: 325),
                    CalculationLineItem(description: "B", quantity: 1, unitPrice: 240),
                    CalculationLineItem(description: "C", quantity: 1, unitPrice: 75)
                ],
                discountType: .percentage,
                discountValue: 5,
                taxPreset: TaxPresetService.preset(for: .BC),
                amountPaid: 0
            )
        )

        XCTAssertEqual(totals.subtotal, Decimal(string: "640.00")!)
        XCTAssertEqual(totals.discountAmount, Decimal(string: "32.00")!)
        XCTAssertEqual(totals.taxableAmount, Decimal(string: "608.00")!)
        XCTAssertEqual(totals.taxAmount, Decimal(string: "72.96")!)
        XCTAssertEqual(totals.total, Decimal(string: "680.96")!)
    }

    func testQuebecTaxComponentsRoundIndependently() {
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: [CalculationLineItem(description: "Service", quantity: 1, unitPrice: 100)],
                discountType: .none,
                discountValue: 0,
                taxPreset: TaxPresetService.preset(for: .QC),
                amountPaid: 0
            )
        )

        XCTAssertEqual(totals.taxLines.map(\.amount), [Decimal(string: "5.00")!, Decimal(string: "9.98")!])
        XCTAssertEqual(totals.taxAmount, Decimal(string: "14.98")!)
        XCTAssertEqual(totals.total, Decimal(string: "114.98")!)
    }

    func testDiscountGreaterThanSubtotalClampsToZero() {
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: [CalculationLineItem(description: "Service", quantity: 1, unitPrice: 100)],
                discountType: .fixed,
                discountValue: 150,
                taxPreset: TaxPresetService.preset(for: .ON),
                amountPaid: 0
            )
        )

        XCTAssertEqual(totals.taxableAmount, Decimal.zero)
        XCTAssertEqual(totals.taxAmount, Decimal.zero)
        XCTAssertEqual(totals.total, Decimal.zero)
        XCTAssertEqual(totals.balanceDue, Decimal.zero)
    }

    func testPercentageDiscountGreaterThanOneHundredPercentClampsToSubtotal() {
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: [CalculationLineItem(description: "Service", quantity: 1, unitPrice: 100)],
                discountType: .percentage,
                discountValue: 150,
                taxPreset: TaxPresetService.preset(for: .ON),
                amountPaid: 0
            )
        )

        XCTAssertEqual(totals.discountAmount, Decimal(string: "100.00")!)
        XCTAssertEqual(totals.total, Decimal.zero)
        XCTAssertEqual(totals.balanceDue, Decimal.zero)
    }

    func testOverpaymentNeverCreatesNegativeBalanceDue() {
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: [CalculationLineItem(description: "Service", quantity: 1, unitPrice: 100)],
                discountType: .none,
                discountValue: 0,
                taxPreset: TaxPresetService.noTax,
                amountPaid: 250
            )
        )

        XCTAssertEqual(totals.total, Decimal(string: "100.00")!)
        XCTAssertEqual(totals.balanceDue, Decimal.zero)
    }

    func testZeroLineItemsProduceZeroTotals() {
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: [],
                discountType: .percentage,
                discountValue: 50,
                taxPreset: TaxPresetService.preset(for: .ON),
                amountPaid: 10
            )
        )

        XCTAssertEqual(totals.subtotal, Decimal.zero)
        XCTAssertEqual(totals.discountAmount, Decimal.zero)
        XCTAssertEqual(totals.taxAmount, Decimal.zero)
        XCTAssertEqual(totals.total, Decimal.zero)
        XCTAssertEqual(totals.balanceDue, Decimal.zero)
    }

    func testFractionalQuantitiesRoundLineTotalsToCurrency() {
        let item = CalculationLineItem(
            description: "Small part",
            quantity: Decimal(string: "3")!,
            unitPrice: Decimal(string: "0.335")!
        )

        XCTAssertEqual(item.lineTotal, Decimal(string: "1.01")!)
    }

    func testNegativeMoneyInputsAreClampedToZero() {
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: [
                    CalculationLineItem(description: "Bad quantity", quantity: -2, unitPrice: 100),
                    CalculationLineItem(description: "Bad rate", quantity: 1, unitPrice: -100),
                    CalculationLineItem(description: "Service", quantity: 1, unitPrice: 100)
                ],
                discountType: .fixed,
                discountValue: -50,
                taxPreset: TaxPresetService.custom(label: "Bad Tax", ratePercent: -13),
                amountPaid: -25
            )
        )

        XCTAssertEqual(totals.subtotal, Decimal(string: "100.00")!)
        XCTAssertEqual(totals.discountAmount, Decimal.zero)
        XCTAssertEqual(totals.taxAmount, Decimal.zero)
        XCTAssertEqual(totals.total, Decimal(string: "100.00")!)
        XCTAssertEqual(totals.balanceDue, Decimal(string: "100.00")!)
    }
}
