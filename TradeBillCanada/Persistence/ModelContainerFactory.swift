import Foundation
import SwiftData

enum ModelContainerFactory {
    static func makeProductionContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Unable to create SwiftData container: \(error)")
        }
    }

    static func makePreviewContainer() -> ModelContainer {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            return try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("Unable to create preview SwiftData container: \(error)")
        }
    }

    private static var schema: Schema {
        Schema([
            BusinessProfile.self,
            Client.self,
            Document.self,
            LineItem.self,
            AppSettings.self,
            PurchaseState.self
        ])
    }
}

