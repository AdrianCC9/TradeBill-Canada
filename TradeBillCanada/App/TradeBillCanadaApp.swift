import SwiftData
import SwiftUI

@main
struct TradeBillCanadaApp: App {
    @StateObject private var purchaseManager = PurchaseManager()
    private let modelContainer = ModelContainerFactory.makeProductionContainer()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .modelContainer(modelContainer)
                .environmentObject(purchaseManager)
                .task {
                    guard !ProcessInfo.processInfo.environment.keys.contains("XCTestConfigurationFilePath") else {
                        return
                    }
                    await purchaseManager.loadProducts()
                    await purchaseManager.refreshEntitlements()
                }
        }
    }
}
