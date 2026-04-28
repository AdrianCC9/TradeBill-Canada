import Foundation
import SwiftData

enum SeedData {
    @MainActor
    static func ensureDefaults(in context: ModelContext) {
        ensureSettings(in: context)
        ensurePurchaseState(in: context)
    }

    @MainActor
    private static func ensureSettings(in context: ModelContext) {
        let descriptor = FetchDescriptor<AppSettings>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        context.insert(AppSettings())
        try? context.save()
    }

    @MainActor
    private static func ensurePurchaseState(in context: ModelContext) {
        let descriptor = FetchDescriptor<PurchaseState>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        context.insert(PurchaseState())
        try? context.save()
    }
}

