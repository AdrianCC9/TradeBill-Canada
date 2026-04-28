import Foundation
import SwiftUI

enum ImageStorageService {
    static func placeholderPath(for name: String) -> String {
        "local://\(name)"
    }
}

