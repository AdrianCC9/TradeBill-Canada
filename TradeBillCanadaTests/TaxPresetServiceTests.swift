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
}
