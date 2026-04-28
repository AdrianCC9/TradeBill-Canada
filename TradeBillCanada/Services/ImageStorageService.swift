import Foundation
import UIKit

enum ImageStorageService {
    enum ImageStorageError: Error {
        case invalidImageData
    }

    private static let imageDirectoryName = "Images"

    static func saveImageData(_ data: Data, filenamePrefix: String) throws -> String {
        guard let image = UIImage(data: data), let pngData = image.pngData() else {
            throw ImageStorageError.invalidImageData
        }

        let directory = try imageDirectory()
        let safePrefix = filenamePrefix
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty ? "image" : filenamePrefix
        let filename = "\(safePrefix)-\(UUID().uuidString).png"
        let url = directory.appendingPathComponent(filename)
        try pngData.write(to: url, options: [.atomic])
        return "\(imageDirectoryName)/\(filename)"
    }

    static func url(for storedPath: String) -> URL? {
        let trimmedPath = storedPath.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPath.isEmpty, !trimmedPath.hasPrefix("local://") else { return nil }

        if trimmedPath.hasPrefix("/") {
            return URL(fileURLWithPath: trimmedPath)
        }

        return documentsDirectory.appendingPathComponent(trimmedPath)
    }

    static func image(for storedPath: String) -> UIImage? {
        guard let url = url(for: storedPath) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    static func deleteImage(at storedPath: String) throws {
        guard let url = url(for: storedPath), FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        try FileManager.default.removeItem(at: url)
    }

    private static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private static func imageDirectory() throws -> URL {
        let directory = documentsDirectory.appendingPathComponent(imageDirectoryName, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }
}
