import Foundation

enum CurrencyFormatter {
    static let cad: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "CAD"
        formatter.locale = Locale(identifier: "en_CA")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static func string(from value: Decimal) -> String {
        cad.string(from: NSDecimalNumber(decimal: value)) ?? "$0.00"
    }

    static func string(fromCents cents: Int) -> String {
        string(from: .dollars(from: cents))
    }
}

