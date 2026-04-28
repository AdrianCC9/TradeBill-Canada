import Foundation

enum DocumentType: String, CaseIterable, Codable, Identifiable {
    case estimate
    case invoice

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .estimate: "Estimate"
        case .invoice: "Invoice"
        }
    }

    var uppercaseName: String { displayName.uppercased() }

    var numberPrefix: String {
        switch self {
        case .estimate: "EST"
        case .invoice: "INV"
        }
    }
}

enum EstimateStatus: String, CaseIterable, Codable, Identifiable {
    case draft
    case sent
    case accepted
    case rejected
    case converted

    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
}

enum InvoiceStatus: String, CaseIterable, Codable, Identifiable {
    case draft
    case sent
    case unpaid
    case partiallyPaid
    case paid
    case overdue
    case cancelled

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .partiallyPaid: "Partially Paid"
        default: rawValue.capitalized
        }
    }
}

enum DiscountType: String, CaseIterable, Codable, Identifiable {
    case none
    case fixed
    case percentage

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .none: "No Discount"
        case .fixed: "Fixed Amount"
        case .percentage: "Percentage"
        }
    }
}

enum CanadianProvince: String, CaseIterable, Codable, Identifiable {
    case AB = "Alberta"
    case BC = "British Columbia"
    case MB = "Manitoba"
    case NB = "New Brunswick"
    case NL = "Newfoundland and Labrador"
    case NT = "Northwest Territories"
    case NS = "Nova Scotia"
    case NU = "Nunavut"
    case ON = "Ontario"
    case PE = "Prince Edward Island"
    case QC = "Quebec"
    case SK = "Saskatchewan"
    case YT = "Yukon"

    var id: String { code }
    var displayName: String { rawValue }

    var code: String {
        switch self {
        case .AB: "AB"
        case .BC: "BC"
        case .MB: "MB"
        case .NB: "NB"
        case .NL: "NL"
        case .NT: "NT"
        case .NS: "NS"
        case .NU: "NU"
        case .ON: "ON"
        case .PE: "PE"
        case .QC: "QC"
        case .SK: "SK"
        case .YT: "YT"
        }
    }
}

