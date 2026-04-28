import XCTest
@testable import TradeBillCanada

final class PDFFilenameServiceTests: XCTestCase {
    func testFilenameSanitizesClientName() {
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0008",
            title: "Main House"
        )
        document.clientNameSnapshot = "Smith / Doe: Main House?"

        XCTAssertEqual(PDFFilenameService.filename(for: document), "Invoice_INV-0008_Smith-Doe-Main-House.pdf")
    }
}

