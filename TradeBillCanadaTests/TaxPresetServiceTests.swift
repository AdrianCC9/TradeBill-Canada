import XCTest
@testable import TradeBillCanada

final class TaxPresetServiceTests: XCTestCase {
    func testNovaScotiaUsesFourteenPercentHST() {
        let preset = TaxPresetService.preset(for: .NS)

        XCTAssertEqual(preset.pdfLabel, "HST 14%")
        XCTAssertEqual(preset.combinedRatePercent, Decimal(14))
    }

    func testBritishColumbiaHasSeparateGSTAndPSTComponents() {
        let preset = TaxPresetService.preset(for: .BC)

        XCTAssertEqual(preset.components.map(\.label), ["GST", "PST"])
        XCTAssertEqual(preset.components.map(\.ratePercent), [Decimal(5), Decimal(7)])
    }

    func testAllProvincePresetsHaveExpectedCombinedRates() {
        let expectedRates: [CanadianProvince: Decimal] = [
            .AB: 5,
            .BC: 12,
            .MB: 12,
            .NB: 15,
            .NL: 15,
            .NT: 5,
            .NS: 14,
            .NU: 5,
            .ON: 13,
            .PE: 15,
            .QC: Decimal(string: "14.975")!,
            .SK: 11,
            .YT: 5
        ]

        CanadianProvince.allCases.forEach { province in
            XCTAssertEqual(
                TaxPresetService.preset(for: province).combinedRatePercent,
                expectedRates[province]!,
                province.code
            )
        }
    }

    func testDocumentCustomTaxPresetUsesSavedLabelAndRate() {
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0001",
            taxProvinceCode: nil,
            taxLabel: "Municipal Tax 7.25%",
            taxRatePercent: 7.25
        )

        let preset = TaxPresetService.preset(for: document)

        XCTAssertEqual(preset.pdfLabel, "Municipal Tax 7.25%")
        XCTAssertEqual(preset.components.map(\.label), ["Municipal Tax"])
        XCTAssertEqual(preset.components.map(\.ratePercent), [Decimal(7.25)])
    }

    func testDocumentWithoutProvinceOrRateUsesNoTax() {
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0001",
            taxProvinceCode: nil,
            taxLabel: "No tax",
            taxRatePercent: 0
        )

        XCTAssertEqual(TaxPresetService.preset(for: document), TaxPresetService.noTax)
    }

    func testDocumentProvinceCodeMatchingIgnoresWhitespaceAndCase() {
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0002",
            taxProvinceCode: " qc ",
            taxLabel: "Ignored 1%",
            taxRatePercent: 1
        )

        XCTAssertEqual(TaxPresetService.preset(for: document).pdfLabel, "GST 5% + QST 9.975%")
    }

    func testCustomTaxLabelStripsEquivalentTrailingPercentageFormats() {
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0003",
            taxProvinceCode: nil,
            taxLabel: "Local Levy 7.250%",
            taxRatePercent: 7.25
        )

        let preset = TaxPresetService.preset(for: document)

        XCTAssertEqual(preset.components.map(\.label), ["Local Levy"])
        XCTAssertEqual(preset.pdfLabel, "Local Levy 7.25%")
    }

    func testMatchingProvinceCodeIgnoresWhitespaceAndCase() {
        XCTAssertEqual(TaxPresetService.preset(matchingProvinceCode: " on ").pdfLabel, "HST 13%")
    }
}
