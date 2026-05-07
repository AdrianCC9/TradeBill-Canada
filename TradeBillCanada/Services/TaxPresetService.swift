import Foundation

enum TaxPresetService {
    static let noTax = TaxPreset(
        id: "no-tax",
        provinceCode: nil,
        displayName: "No tax",
        pdfLabel: "No tax",
        components: []
    )

    static var provincePresets: [TaxPreset] {
        CanadianProvince.allCases.map { preset(for: $0) }
    }

    static func preset(for province: CanadianProvince) -> TaxPreset {
        switch province {
        case .AB:
            simple(province: province, label: "GST", rate: "5")
        case .BC:
            combined(province: province, components: [("GST", "5"), ("PST", "7")])
        case .MB:
            combined(province: province, components: [("GST", "5"), ("RST", "7")])
        case .NB, .NL, .PE:
            simple(province: province, label: "HST", rate: "15")
        case .NT, .NU, .YT:
            simple(province: province, label: "GST", rate: "5")
        case .NS:
            simple(province: province, label: "HST", rate: "14")
        case .ON:
            simple(province: province, label: "HST", rate: "13")
        case .QC:
            combined(province: province, components: [("GST", "5"), ("QST", "9.975")])
        case .SK:
            combined(province: province, components: [("GST", "5"), ("PST", "6")])
        }
    }

    static func custom(label: String, ratePercent: Decimal) -> TaxPreset {
        let cleanLabel = label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Custom Tax"
            : label.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanRatePercent = ratePercent.clampedToNonNegative
        return TaxPreset(
            id: "custom-\(cleanLabel)-\(cleanRatePercent)",
            provinceCode: nil,
            displayName: "\(cleanLabel) \(cleanRatePercent)%",
            pdfLabel: "\(cleanLabel) \(cleanRatePercent)%",
            components: [TaxComponent(label: cleanLabel, ratePercent: cleanRatePercent)]
        )
    }

    static func preset(for document: Document) -> TaxPreset {
        let cleanProvinceCode = document.taxProvinceCode?.trimmedForStorage.uppercased()
        if
            let code = cleanProvinceCode,
            let province = CanadianProvince.allCases.first(where: { $0.code == code })
        {
            return preset(for: province)
        }

        guard document.taxRatePercent > 0 else {
            return noTax
        }

        return custom(
            label: customLabel(from: document.taxLabel, ratePercent: document.taxRatePercent),
            ratePercent: Decimal(document.taxRatePercent)
        )
    }

    static func preset(matchingProvinceCode code: String?) -> TaxPreset {
        let cleanCode = code?.trimmedForStorage.uppercased()
        guard
            let code = cleanCode,
            let province = CanadianProvince.allCases.first(where: { $0.code == code })
        else {
            return noTax
        }
        return preset(for: province)
    }

    private static func customLabel(from taxLabel: String, ratePercent _: Double) -> String {
        let fallback = "Custom Tax"
        let trimmed = taxLabel.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != noTax.pdfLabel else { return fallback }

        let label = trimmed
            .replacingOccurrences(
                of: #"\s+\d+(?:\.\d+)?\s*%$"#,
                with: "",
                options: .regularExpression
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return label.isEmpty ? fallback : label
    }

    private static func simple(province: CanadianProvince, label: String, rate: String) -> TaxPreset {
        let percent = Decimal(string: rate) ?? .zero
        return TaxPreset(
            id: province.code,
            provinceCode: province.code,
            displayName: "\(province.displayName) - \(label) \(rate)%",
            pdfLabel: "\(label) \(rate)%",
            components: [TaxComponent(label: label, ratePercent: percent)]
        )
    }

    private static func combined(province: CanadianProvince, components: [(String, String)]) -> TaxPreset {
        let taxComponents = components.map {
            TaxComponent(label: $0.0, ratePercent: Decimal(string: $0.1) ?? .zero)
        }
        let label = components.map { "\($0.0) \($0.1)%" }.joined(separator: " + ")
        return TaxPreset(
            id: province.code,
            provinceCode: province.code,
            displayName: "\(province.displayName) - \(label)",
            pdfLabel: label,
            components: taxComponents
        )
    }
}
