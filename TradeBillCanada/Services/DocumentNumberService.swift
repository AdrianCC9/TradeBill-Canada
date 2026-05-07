import Foundation

enum DocumentNumberService {
    static func nextNumber(for type: DocumentType, settings: AppSettings) -> String {
        let next = max(type == .invoice ? settings.nextInvoiceNumber : settings.nextEstimateNumber, 1)
        return "\(type.numberPrefix)-\(String(format: "%04d", next))"
    }

    static func consumeNextNumber(for type: DocumentType, settings: AppSettings) {
        switch type {
        case .invoice:
            settings.nextInvoiceNumber = max(settings.nextInvoiceNumber, 1) + 1
        case .estimate:
            settings.nextEstimateNumber = max(settings.nextEstimateNumber, 1) + 1
        }
    }
}
