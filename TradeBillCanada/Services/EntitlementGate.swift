import Foundation

enum EntitlementGate {
    static let freeDocumentLimit = 3

    static func canCreateDocument(settings: AppSettings?, purchaseState: PurchaseState?) -> Bool {
        isUnlocked(settings: settings, purchaseState: purchaseState)
            || (settings?.freeDocumentsCreated ?? 0) < freeDocumentLimit
    }

    static func canExportPDF(settings: AppSettings?, purchaseState: PurchaseState?) -> Bool {
        canCreateDocument(settings: settings, purchaseState: purchaseState)
    }

    static func isUnlocked(settings: AppSettings?, purchaseState: PurchaseState?) -> Bool {
        (settings?.hasLifetimeUnlock ?? false) || (purchaseState?.hasLifetimeUnlock ?? false)
    }
}

