import Foundation

extension Decimal {
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
        Decimal(string: replacingOccurrences(of: ",", with: "")) ?? .zero
    }
}

