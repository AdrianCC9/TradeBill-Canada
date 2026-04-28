import Foundation

enum StoreError: LocalizedError {
    case failedVerification
    case productUnavailable

    var errorDescription: String? {
        switch self {
        case .failedVerification:
            "The purchase could not be verified."
        case .productUnavailable:
            "The lifetime unlock is not available right now."
        }
    }
}

