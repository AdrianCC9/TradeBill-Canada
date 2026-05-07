import Foundation
import SwiftData

@Model
final class Document {
    var id: UUID
    var typeRawValue: String
    var documentNumber: String
    var client: Client?
    var clientNameSnapshot: String
    var clientCompanySnapshot: String
    var clientEmailSnapshot: String
    var clientPhoneSnapshot: String
    var clientAddressSnapshot: String
    var title: String
    var jobAddress: String
    var issueDate: Date
    var dueDate: Date
    var statusRawValue: String
    var subtotalCents: Int
    var discountTypeRawValue: String
    var discountValueCents: Int
    var discountPercentage: Double
    var taxProvinceCode: String?
    var taxLabel: String
    var taxRatePercent: Double
    var taxAmountCents: Int
    var amountPaidCents: Int
    var totalCents: Int
    var balanceDueCents: Int
    var notes: String
    var terms: String
    var convertedFromEstimateId: UUID?
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \LineItem.document)
    var lineItems: [LineItem]

    init(
        id: UUID = UUID(),
        type: DocumentType,
        documentNumber: String,
        client: Client? = nil,
        title: String = "",
        jobAddress: String = "",
        issueDate: Date = .now,
        dueDate: Date = Calendar.current.date(byAdding: .day, value: 14, to: .now) ?? .now,
        statusRawValue: String? = nil,
        subtotalCents: Int = 0,
        discountType: DiscountType = .none,
        discountValueCents: Int = 0,
        discountPercentage: Double = 0,
        taxProvinceCode: String? = CanadianProvince.ON.code,
        taxLabel: String = "HST 13%",
        taxRatePercent: Double = 13,
        taxAmountCents: Int = 0,
        amountPaidCents: Int = 0,
        totalCents: Int = 0,
        balanceDueCents: Int = 0,
        notes: String = "",
        terms: String = "",
        convertedFromEstimateId: UUID? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        lineItems: [LineItem] = []
    ) {
        self.id = id
        self.typeRawValue = type.rawValue
        self.documentNumber = documentNumber
        self.client = client
        self.clientNameSnapshot = client?.name ?? ""
        self.clientCompanySnapshot = client?.companyName ?? ""
        self.clientEmailSnapshot = client?.email ?? ""
        self.clientPhoneSnapshot = client?.phone ?? ""
        self.clientAddressSnapshot = client?.singleLineAddress ?? ""
        self.title = title
        self.jobAddress = jobAddress
        self.issueDate = issueDate
        self.dueDate = dueDate
        self.statusRawValue = statusRawValue ?? (type == .invoice ? InvoiceStatus.unpaid.rawValue : EstimateStatus.draft.rawValue)
        self.subtotalCents = subtotalCents
        self.discountTypeRawValue = discountType.rawValue
        self.discountValueCents = discountValueCents
        self.discountPercentage = discountPercentage
        self.taxProvinceCode = taxProvinceCode
        self.taxLabel = taxLabel
        self.taxRatePercent = taxRatePercent
        self.taxAmountCents = taxAmountCents
        self.amountPaidCents = amountPaidCents
        self.totalCents = totalCents
        self.balanceDueCents = balanceDueCents
        self.notes = notes
        self.terms = terms
        self.convertedFromEstimateId = convertedFromEstimateId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lineItems = lineItems
    }

    var type: DocumentType {
        get { DocumentType(rawValue: typeRawValue) ?? .invoice }
        set { typeRawValue = newValue.rawValue }
    }

    var discountType: DiscountType {
        get { DiscountType(rawValue: discountTypeRawValue) ?? .none }
        set { discountTypeRawValue = newValue.rawValue }
    }

    var displayClientName: String {
        let cleanName = clientNameSnapshot.trimmedForStorage
        let cleanCompanyName = clientCompanySnapshot.trimmedForStorage
        if !cleanName.isEmpty, !cleanCompanyName.isEmpty {
            return "\(cleanName) - \(cleanCompanyName)"
        }
        if !cleanName.isEmpty { return cleanName }
        if !cleanCompanyName.isEmpty { return cleanCompanyName }
        if let client { return client.displayName }
        return "No client"
    }

    var statusDisplayName: String {
        switch type {
        case .estimate:
            return EstimateStatus(rawValue: statusRawValue)?.displayName ?? statusRawValue.capitalized
        case .invoice:
            if isOverdue {
                return InvoiceStatus.overdue.displayName
            }
            return InvoiceStatus(rawValue: statusRawValue)?.displayName ?? statusRawValue.capitalized
        }
    }

    var isOverdue: Bool {
        guard type == .invoice else { return false }
        guard balanceDueCents > 0 else { return false }
        guard statusRawValue != InvoiceStatus.paid.rawValue && statusRawValue != InvoiceStatus.cancelled.rawValue else {
            return false
        }
        return dueDate < Calendar.current.startOfDay(for: .now)
    }

    var sortedLineItems: [LineItem] {
        lineItems.sorted { $0.sortOrder < $1.sortOrder }
    }

    func updateClientSnapshot() {
        guard let client else {
            clientNameSnapshot = ""
            clientCompanySnapshot = ""
            clientEmailSnapshot = ""
            clientPhoneSnapshot = ""
            clientAddressSnapshot = ""
            return
        }

        clientNameSnapshot = client.name.trimmedForStorage
        clientCompanySnapshot = client.companyName.trimmedForStorage
        clientEmailSnapshot = client.email.trimmedForStorage
        clientPhoneSnapshot = client.phone.trimmedForStorage
        clientAddressSnapshot = client.singleLineAddress
    }
}
