import Foundation
import SwiftData

@Model
final class PurchaseState {
    var id: UUID
    var hasLifetimeUnlock: Bool
    var lastVerifiedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        hasLifetimeUnlock: Bool = false,
        lastVerifiedAt: Date? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.hasLifetimeUnlock = hasLifetimeUnlock
        self.lastVerifiedAt = lastVerifiedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

