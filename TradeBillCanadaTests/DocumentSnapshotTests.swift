import XCTest
@testable import TradeBillCanada

final class DocumentSnapshotTests: XCTestCase {
    func testClearingClientClearsClientSnapshot() {
        let client = Client(
            name: "Jane Client",
            companyName: "Jane Co.",
            email: "jane@example.com",
            phone: "555-0100",
            addressLine1: "123 Main St",
            city: "Toronto",
            provinceCode: CanadianProvince.ON.code,
            postalCode: "M5V 1A1"
        )
        let document = Document(type: .invoice, documentNumber: "INV-0001", client: client)

        document.client = nil
        document.updateClientSnapshot()

        XCTAssertEqual(document.displayClientName, "No client")
        XCTAssertEqual(document.clientNameSnapshot, "")
        XCTAssertEqual(document.clientCompanySnapshot, "")
        XCTAssertEqual(document.clientEmailSnapshot, "")
        XCTAssertEqual(document.clientPhoneSnapshot, "")
        XCTAssertEqual(document.clientAddressSnapshot, "")
    }

    func testPastDueUnpaidInvoiceDisplaysOverdue() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))!
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0002",
            dueDate: yesterday,
            statusRawValue: InvoiceStatus.unpaid.rawValue,
            balanceDueCents: 10_000
        )

        XCTAssertTrue(document.isOverdue)
        XCTAssertEqual(document.statusDisplayName, "Overdue")
    }

    func testPaidPastDueInvoiceDoesNotDisplayOverdue() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))!
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0003",
            dueDate: yesterday,
            statusRawValue: InvoiceStatus.paid.rawValue,
            balanceDueCents: 0
        )

        XCTAssertFalse(document.isOverdue)
        XCTAssertEqual(document.statusDisplayName, "Paid")
    }

    func testCancelledPastDueInvoiceDoesNotDisplayOverdue() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))!
        let document = Document(
            type: .invoice,
            documentNumber: "INV-0004",
            dueDate: yesterday,
            statusRawValue: InvoiceStatus.cancelled.rawValue,
            balanceDueCents: 10_000
        )

        XCTAssertFalse(document.isOverdue)
        XCTAssertEqual(document.statusDisplayName, "Cancelled")
    }

    func testEstimateNeverDisplaysOverdueEvenWhenPastDueWithBalance() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: .now))!
        let document = Document(
            type: .estimate,
            documentNumber: "EST-0001",
            dueDate: yesterday,
            statusRawValue: EstimateStatus.sent.rawValue,
            balanceDueCents: 10_000
        )

        XCTAssertFalse(document.isOverdue)
        XCTAssertEqual(document.statusDisplayName, "Sent")
    }
}
