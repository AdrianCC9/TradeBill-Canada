import Foundation

struct TaxComponent: Codable, Hashable, Identifiable {
    var id: String { "\(label)-\(ratePercent)" }

    let label: String
    let ratePercent: Decimal
}

struct TaxPreset: Codable, Hashable, Identifiable {
    let id: String
    let provinceCode: String?
    let displayName: String
    let pdfLabel: String
    let components: [TaxComponent]

    var combinedRatePercent: Decimal {
        components.reduce(Decimal.zero) { $0 + $1.ratePercent }
    }
}

struct TaxBreakdownLine: Hashable, Identifiable {
    var id: String { "\(label)-\(ratePercent)-\(amount)" }

    let label: String
    let ratePercent: Decimal
    let amount: Decimal
}

