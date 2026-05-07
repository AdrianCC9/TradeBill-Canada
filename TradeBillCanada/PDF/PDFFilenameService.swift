import Foundation

enum PDFFilenameService {
    static func filename(for document: Document) -> String {
        let type = document.type.displayName
        let number = FilenameSanitizer.sanitize(document.documentNumber)
        let displayClientName = document.displayClientName
        let client = displayClientName == "No client" ? "Client" : FilenameSanitizer.sanitize(displayClientName)
        return "\(type)_\(number)_\(client).pdf"
    }
}
