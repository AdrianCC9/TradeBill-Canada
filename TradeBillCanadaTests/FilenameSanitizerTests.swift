import XCTest
@testable import TradeBillCanada

final class FilenameSanitizerTests: XCTestCase {
    func testSanitizeReplacesUnsafeCharactersAndNormalizesWhitespace() {
        XCTAssertEqual(FilenameSanitizer.sanitize(" Smith / Doe: Main House? "), "Smith-Doe-Main-House")
    }

    func testSanitizeFallsBackForBlankOrPunctuationOnlyValues() {
        XCTAssertEqual(FilenameSanitizer.sanitize("   ///   "), "Client")
    }

    func testSanitizeCapsVeryLongSegments() {
        let sanitized = FilenameSanitizer.sanitize(String(repeating: "A", count: 300))

        XCTAssertLessThanOrEqual(sanitized.count, 80)
    }
}
