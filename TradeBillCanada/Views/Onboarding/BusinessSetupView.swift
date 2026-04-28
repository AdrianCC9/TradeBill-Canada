import SwiftData
import SwiftUI

struct BusinessSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var existingProfile: BusinessProfile?
    var onSkip: (() -> Void)?

    @State private var businessName = ""
    @State private var ownerName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var addressLine1 = ""
    @State private var city = ""
    @State private var province = CanadianProvince.ON
    @State private var postalCode = ""
    @State private var taxNumber = ""
    @State private var defaultTerms = "Payment due within 14 days."

    var body: some View {
        Form {
            Section {
                TextField("Business name", text: $businessName)
                TextField("Owner name", text: $ownerName)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            } header: {
                Text("Business")
            }

            Section {
                TextField("Address", text: $addressLine1)
                TextField("City", text: $city)
                Picker("Province", selection: $province) {
                    ForEach(CanadianProvince.allCases) { province in
                        Text(province.displayName).tag(province)
                    }
                }
                TextField("Postal code", text: $postalCode)
                    .textInputAutocapitalization(.characters)
                TextField("Tax number (optional)", text: $taxNumber)
            } header: {
                Text("Defaults")
            }

            Section {
                TextField("Default payment terms", text: $defaultTerms, axis: .vertical)
                    .lineLimit(2...4)
            }

            Section {
                PrimaryButton(title: existingProfile == nil ? "Save Business Profile" : "Update Business Profile") {
                    save()
                }

                if let onSkip {
                    Button("Skip for now") {
                        onSkip()
                    }
                    .foregroundStyle(AppTheme.mutedText)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.offWhite)
        .navigationTitle(existingProfile == nil ? "Business Setup" : "Business Profile")
        .onAppear(perform: populate)
    }

    private func populate() {
        guard let existingProfile else { return }
        businessName = existingProfile.businessName
        ownerName = existingProfile.ownerName
        phone = existingProfile.phone
        email = existingProfile.email
        addressLine1 = existingProfile.addressLine1
        city = existingProfile.city
        province = existingProfile.province
        postalCode = existingProfile.postalCode
        taxNumber = existingProfile.taxNumber
        defaultTerms = existingProfile.defaultPaymentTerms
    }

    private func save() {
        let profile = existingProfile ?? BusinessProfile()
        profile.businessName = businessName
        profile.ownerName = ownerName
        profile.phone = phone
        profile.email = email
        profile.addressLine1 = addressLine1
        profile.city = city
        profile.provinceCode = province.code
        profile.postalCode = postalCode
        profile.taxNumber = taxNumber
        profile.defaultTaxProvinceCode = province.code
        profile.defaultPaymentTerms = defaultTerms
        profile.updatedAt = .now

        if existingProfile == nil {
            modelContext.insert(profile)
        }
        try? modelContext.save()
        dismiss()
    }
}

