import Foundation
import SwiftData

@Model
final class Client {
    var id: UUID
    var name: String
    var companyName: String
    var email: String
    var phone: String
    var addressLine1: String
    var addressLine2: String
    var city: String
    var provinceCode: String
    var postalCode: String
    var notes: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String = "",
        companyName: String = "",
        email: String = "",
        phone: String = "",
        addressLine1: String = "",
        addressLine2: String = "",
        city: String = "",
        provinceCode: String = CanadianProvince.ON.code,
        postalCode: String = "",
        notes: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.companyName = companyName
        self.email = email
        self.phone = phone
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.provinceCode = provinceCode
        self.postalCode = postalCode
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var displayName: String {
        if !companyName.isEmpty, !name.isEmpty {
            return "\(name) - \(companyName)"
        }
        return name.isEmpty ? "Unnamed Client" : name
    }

    var singleLineAddress: String {
        [addressLine1, addressLine2, city, provinceCode, postalCode]
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .joined(separator: ", ")
    }
}

