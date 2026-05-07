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

    func testFilenameSanitizesDocumentNumberAndFallsBackForMissingClient() {
        let document = Document(
            type: .estimate,
            documentNumber: "EST/0009:final?",
            title: "Main House"
        )

        XCTAssertEqual(PDFFilenameService.filename(for: document), "Estimate_EST-0009-final_Client.pdf")
    }

    func testFilenameCanUseCompanyOnlyClientSnapshot() {
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0010",
            title: "Main House"
        )
        document.clientCompanySnapshot = "Acme Services"

        XCTAssertEqual(PDFFilenameService.filename(for: document), "Invoice_INV-0010_Acme-Services.pdf")
    }
}
