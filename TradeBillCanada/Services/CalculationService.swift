import Foundation

struct CalculationLineItem: Hashable {
    var description: String
    var quantity: Decimal
    var unitPrice: Decimal

    var normalizedQuantity: Decimal {
        quantity.clampedToNonNegative
    }

    var normalizedUnitPrice: Decimal {
        unitPrice.clampedToNonNegative
    }

    var lineTotal: Decimal {
        (normalizedQuantity * normalizedUnitPrice).roundedCurrency()
    }
}

struct CalculationInput {
    var lineItems: [CalculationLineItem]
    var discountType: DiscountType
    var discountValue: Decimal
    var taxPreset: TaxPreset
    var amountPaid: Decimal
}

struct DocumentTotals: Hashable {
    var subtotal: Decimal
    var discountAmount: Decimal
    var taxableAmount: Decimal
    var taxLines: [TaxBreakdownLine]
    var taxAmount: Decimal
    var total: Decimal
    var balanceDue: Decimal
}

enum CalculationService {
    static func calculate(_ input: CalculationInput) -> DocumentTotals {
        let subtotal = input.lineItems
            .map(\.lineTotal)
            .reduce(Decimal.zero, +)
            .roundedCurrency()

        let discountAmount = calculateDiscount(
            subtotal: subtotal,
            type: input.discountType,
            value: input.discountValue.clampedToNonNegative
        )

        let taxableAmount = max(subtotal - discountAmount, .zero).roundedCurrency()

        let taxLines = input.taxPreset.components.map { component in
            let ratePercent = component.ratePercent.clampedToNonNegative
            let amount = (taxableAmount * ratePercent / Decimal(100)).roundedCurrency()
            return TaxBreakdownLine(label: component.label, ratePercent: ratePercent, amount: amount)
        }

        let taxAmount = taxLines.map(\.amount).reduce(Decimal.zero, +).roundedCurrency()
        let total = max(taxableAmount + taxAmount, .zero).roundedCurrency()
        let balanceDue = max(total - input.amountPaid.clampedToNonNegative, .zero).roundedCurrency()

        return DocumentTotals(
            subtotal: subtotal,
            discountAmount: discountAmount,
            taxableAmount: taxableAmount,
            taxLines: taxLines,
            taxAmount: taxAmount,
            total: total,
            balanceDue: balanceDue
        )
    }

    private static func calculateDiscount(subtotal: Decimal, type: DiscountType, value: Decimal) -> Decimal {
        guard subtotal > .zero else { return .zero }

        let rawDiscount: Decimal
        switch type {
        case .none:
            rawDiscount = .zero
        case .fixed:
            rawDiscount = value
        case .percentage:
            rawDiscount = subtotal * value / Decimal(100)
        }

        return min(max(rawDiscount, .zero), subtotal).roundedCurrency()
    }
}
