import Foundation

enum DocumentNumberService {
    static func nextNumber(for type: DocumentType, settings: AppSettings) -> String {
        let next = type == .invoice ? settings.nextInvoiceNumber : settings.nextEstimateNumber
        return "\(type.numberPrefix)-\(String(format: "%04d", next))"
    }

    static func consumeNextNumber(for type: DocumentType, settings: AppSettings) {
        switch type {
        case .invoice:
            settings.nextInvoiceNumber += 1
        case .estimate:
            settings.nextEstimateNumber += 1
        }
    }
}

