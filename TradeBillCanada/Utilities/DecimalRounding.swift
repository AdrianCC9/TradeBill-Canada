import Foundation

extension Decimal {
    var clampedToNonNegative: Decimal {
        self < .zero ? .zero : self
    }

    func rounded(scale: Int = 2, mode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        var value = self
        var result = Decimal()
        NSDecimalRound(&result, &value, scale, mode)
        return result
    }

    func roundedCurrency() -> Decimal {
        rounded(scale: 2, mode: .plain)
    }

    var cents: Int {
        let scaled = (self * Decimal(100)).rounded(scale: 0, mode: .plain)
        return NSDecimalNumber(decimal: scaled).intValue
    }

    static func dollars(from cents: Int) -> Decimal {
        Decimal(cents) / Decimal(100)
    }
}

extension String {
    var decimalValue: Decimal {
        let cleanValue = trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "$", with: "")
        return Decimal(string: cleanValue) ?? .zero
    }

    var nonNegativeDecimalValue: Decimal {
        decimalValue.clampedToNonNegative
    }

    var trimmedForStorage: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
