import XCTest
@testable import TradeBillCanada

final class StoreKitConfigurationTests: XCTestCase {
    private struct StoreKitConfiguration: Decodable {
        var products: [StoreKitProduct]
    }

    private struct StoreKitProduct: Decodable {
        var productID: String
        var type: String
        var displayPrice: String
        var localizations: [StoreKitLocalization]
    }

    private struct StoreKitLocalization: Decodable {
        var displayName: String
        var description: String
        var locale: String
    }

    func testLocalStoreKitConfigurationDeclaresLifetimeProduct() throws {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Configuration.storekit")
        let data = try Data(contentsOf: url)
        let configuration = try JSONDecoder().decode(StoreKitConfiguration.self, from: data)
        let product = try XCTUnwrap(configuration.products.first { $0.productID == ProductIDs.lifetimeUnlock })

        XCTAssertEqual(product.type, "NonConsumable")
        XCTAssertEqual(product.displayPrice, "19.99")
        XCTAssertTrue(product.localizations.contains { localization in
            localization.locale == "en_CA"
                && localization.displayName == "Lifetime Unlock"
                && localization.description.localizedCaseInsensitiveContains("No subscription")
        })
    }

    func testLocalStoreKitConfigurationDoesNotDeclareDuplicateProductIds() throws {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Configuration.storekit")
        let data = try Data(contentsOf: url)
        let configuration = try JSONDecoder().decode(StoreKitConfiguration.self, from: data)
        let productIDs = configuration.products.map(\.productID)

        XCTAssertEqual(productIDs.count, Set(productIDs).count)
    }
}
