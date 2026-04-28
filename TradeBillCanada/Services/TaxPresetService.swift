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
        TaxPreset(
            id: "custom-\(label)-\(ratePercent)",
            provinceCode: nil,
            displayName: "\(label) \(ratePercent)%",
            pdfLabel: "\(label) \(ratePercent)%",
            components: [TaxComponent(label: label, ratePercent: ratePercent)]
        )
    }

    static func preset(matchingProvinceCode code: String?) -> TaxPreset {
        guard
            let code,
            let province = CanadianProvince.allCases.first(where: { $0.code == code })
        else {
            return noTax
        }
        return preset(for: province)
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

