import XCTest
@testable import TradeBillCanada

final class ModelDisplayTests: XCTestCase {
    func testClientDisplayUsesCompanyWhenContactNameIsBlank() {
        let client = Client(name: "   ", companyName: "  Acme Services  ")

        XCTAssertEqual(client.displayName, "Acme Services")
    }

    func testClientDisplayTrimsNameAndCompany() {
        let client = Client(name: "  Jane  ", companyName: "  Jane Co.  ")

        XCTAssertEqual(client.displayName, "Jane - Jane Co.")
    }

    func testClientSingleLineAddressTrimsAndSkipsBlankParts() {
        let client = Client(
            addressLine1: "  123 Main St  ",
            addressLine2: "   ",
            city: " Toronto ",
            provinceCode: " ON ",
            postalCode: " M5V 1A1 "
        )

        XCTAssertEqual(client.singleLineAddress, "123 Main St, Toronto, ON, M5V 1A1")
    }

    func testBusinessProfileSingleLineAddressTrimsAndSkipsBlankParts() {
        let profile = BusinessProfile(
            addressLine1: "  44 King St  ",
            addressLine2: "\n",
            city: " Halifax ",
            provinceCode: " NS ",
            postalCode: " B3J 1A1 "
        )

        XCTAssertEqual(profile.singleLineAddress, "44 King St, Halifax, NS, B3J 1A1")
    }

    func testBusinessProfileProvinceLookupsAreCaseInsensitive() {
        let profile = BusinessProfile(provinceCode: " qc ", defaultTaxProvinceCode: " bc ")

        XCTAssertEqual(profile.province, .QC)
        XCTAssertEqual(profile.defaultTaxProvince, .BC)
    }

    func testDocumentDisplayUsesCompanySnapshotWhenNameSnapshotIsBlank() {
        let document = Document(type: .invoice, documentNumber: "INV-0001")
        document.clientNameSnapshot = "   "
        document.clientCompanySnapshot = "  Northern Lights Cleaning  "

        XCTAssertEqual(document.displayClientName, "Northern Lights Cleaning")
    }

    func testDocumentClientSnapshotTrimsClientFields() {
        let client = Client(
            name: " Jane ",
            companyName: " Jane Co. ",
            email: " jane@example.com ",
            phone: " 555-0100 ",
            addressLine1: " 123 Main ",
            city: " Toronto ",
            provinceCode: " ON ",
            postalCode: " M5V 1A1 "
        )
        let document = Document(type: .invoice, documentNumber: "INV-0002", client: client)

        document.updateClientSnapshot()

        XCTAssertEqual(document.clientNameSnapshot, "Jane")
        XCTAssertEqual(document.clientCompanySnapshot, "Jane Co.")
        XCTAssertEqual(document.clientEmailSnapshot, "jane@example.com")
        XCTAssertEqual(document.clientPhoneSnapshot, "555-0100")
        XCTAssertEqual(document.clientAddressSnapshot, "123 Main, Toronto, ON, M5V 1A1")
    }
}
