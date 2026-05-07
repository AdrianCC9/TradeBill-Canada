import XCTest
@testable import TradeBillCanada

final class DecimalParsingTests: XCTestCase {
    func testDecimalValueAcceptsWhitespaceCommasAndDollarSigns() {
        XCTAssertEqual("  $1,234.56  ".decimalValue, Decimal(string: "1234.56"))
    }

    func testDecimalValueFallsBackToZeroForInvalidInput() {
        XCTAssertEqual("not money".decimalValue, .zero)
        XCTAssertEqual("".decimalValue, .zero)
    }

    func testNonNegativeDecimalValueClampsPastedNegativeAmounts() {
        XCTAssertEqual("-42.25".nonNegativeDecimalValue, .zero)
    }
}
