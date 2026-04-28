import Foundation

enum AppRoute: Hashable {
    case document(UUID)
    case client(UUID)
    case settings
}

