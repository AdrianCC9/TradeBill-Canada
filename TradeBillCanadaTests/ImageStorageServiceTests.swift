import UIKit
import XCTest
@testable import TradeBillCanada

final class ImageStorageServiceTests: XCTestCase {
    func testSaveImageRejectsInvalidData() {
        XCTAssertThrowsError(try ImageStorageService.saveImageData(Data("nope".utf8), filenamePrefix: "logo"))
    }

    func testSaveImageSanitizesPrefixAndReturnsRelativeImagePath() throws {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 2, height: 2))
        let data = renderer.pngData { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 2, height: 2))
        }

        let path = try ImageStorageService.saveImageData(data, filenamePrefix: " ../bad prefix? ")
        defer { try? ImageStorageService.deleteImage(at: path) }

        XCTAssertTrue(path.hasPrefix("Images/bad-prefix-"))
        XCTAssertTrue(path.hasSuffix(".png"))
        XCTAssertFalse(path.contains(".."))
        XCTAssertNotNil(ImageStorageService.image(for: path))
    }
}
