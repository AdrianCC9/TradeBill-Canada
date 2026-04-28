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
}

