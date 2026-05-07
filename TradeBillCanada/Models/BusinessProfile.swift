import Foundation
import SwiftData

@Model
final class BusinessProfile {
    var id: UUID
    var businessName: String
    var ownerName: String
    var email: String
    var phone: String
    var addressLine1: String
    var addressLine2: String
    var city: String
    var provinceCode: String
    var postalCode: String
    var taxNumber: String
    var logoImagePath: String
    var signatureImagePath: String
    var defaultTaxProvinceCode: String
    var defaultPaymentTerms: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        businessName: String = "",
        ownerName: String = "",
        email: String = "",
        phone: String = "",
        addressLine1: String = "",
        addressLine2: String = "",
        city: String = "",
        provinceCode: String = CanadianProvince.ON.code,
        postalCode: String = "",
        taxNumber: String = "",
        logoImagePath: String = "",
        signatureImagePath: String = "",
        defaultTaxProvinceCode: String = CanadianProvince.ON.code,
        defaultPaymentTerms: String = "Payment due within 14 days.",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.businessName = businessName
        self.ownerName = ownerName
        self.email = email
        self.phone = phone
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.provinceCode = provinceCode
        self.postalCode = postalCode
        self.taxNumber = taxNumber
        self.logoImagePath = logoImagePath
        self.signatureImagePath = signatureImagePath
        self.defaultTaxProvinceCode = defaultTaxProvinceCode
        self.defaultPaymentTerms = defaultPaymentTerms
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var province: CanadianProvince {
        let cleanCode = provinceCode.trimmedForStorage.uppercased()
        return CanadianProvince.allCases.first { $0.code == cleanCode } ?? .ON
    }

    var defaultTaxProvince: CanadianProvince {
        let cleanCode = defaultTaxProvinceCode.trimmedForStorage.uppercased()
        return CanadianProvince.allCases.first { $0.code == cleanCode } ?? .ON
    }

    var singleLineAddress: String {
        [addressLine1, addressLine2, city, provinceCode, postalCode]
            .map(\.trimmedForStorage)
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}
