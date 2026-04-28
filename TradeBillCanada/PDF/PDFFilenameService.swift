import Foundation

enum PDFFilenameService {
    static func filename(for document: Document) -> String {
        let type = document.type.displayName
        let client = FilenameSanitizer.sanitize(document.displayClientName)
        return "\(type)_\(document.documentNumber)_\(client).pdf"
    }
}

