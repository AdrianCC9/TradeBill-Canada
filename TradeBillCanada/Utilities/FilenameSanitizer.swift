import Foundation

enum FilenameSanitizer {
    static func sanitize(_ value: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_ "))
        let scalars = value.unicodeScalars.map { allowed.contains($0) ? Character($0) : "-" }
        let normalized = String(scalars)
            .replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
            .replacingOccurrences(of: "-+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-_ "))
        return normalized.isEmpty ? "Client" : normalized
    }
}

