import Foundation
import SwiftData

@Model
final class AppSettings {
    var id: UUID
    var nextInvoiceNumber: Int
    var nextEstimateNumber: Int
    var freeDocumentsCreated: Int
    var hasLifetimeUnlock: Bool
    var currencyCode: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        nextInvoiceNumber: Int = 1,
        nextEstimateNumber: Int = 1,
        freeDocumentsCreated: Int = 0,
        hasLifetimeUnlock: Bool = false,
        currencyCode: String = "CAD",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.nextInvoiceNumber = nextInvoiceNumber
        self.nextEstimateNumber = nextEstimateNumber
        self.freeDocumentsCreated = freeDocumentsCreated
        self.hasLifetimeUnlock = hasLifetimeUnlock
        self.currencyCode = currencyCode
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

