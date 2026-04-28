import Foundation

enum DateFormatterFactory {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_CA")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

