import Foundation
import SwiftData

@Model
final class LineItem {
    var id: UUID
    var itemDescription: String
    var quantity: Double
    var unitPriceCents: Int
    var sortOrder: Int
    var document: Document?

    init(
        id: UUID = UUID(),
        itemDescription: String = "",
        quantity: Double = 1,
        unitPriceCents: Int = 0,
        sortOrder: Int = 0,
        document: Document? = nil
    ) {
        self.id = id
        self.itemDescription = itemDescription
        self.quantity = quantity
        self.unitPriceCents = unitPriceCents
        self.sortOrder = sortOrder
        self.document = document
    }

    var unitPrice: Decimal {
        Decimal.dollars(from: unitPriceCents)
    }

    var calculationLineItem: CalculationLineItem {
        CalculationLineItem(
            description: itemDescription,
            quantity: Decimal(quantity).clampedToNonNegative,
            unitPrice: unitPrice.clampedToNonNegative
        )
    }

    var lineTotalCents: Int {
        calculationLineItem.lineTotal.cents
    }
}
