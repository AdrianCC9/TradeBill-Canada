import PhotosUI
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
    @State private var addressLine2 = ""
    @State private var city = ""
    @State private var province = CanadianProvince.ON
    @State private var postalCode = ""
    @State private var taxNumber = ""
    @State private var defaultTaxProvince = CanadianProvince.ON
    @State private var defaultTerms = "Payment due within 14 days."
    @State private var logoImagePath = ""
    @State private var signatureImagePath = ""
    @State private var selectedLogoItem: PhotosPickerItem?
    @State private var selectedSignatureItem: PhotosPickerItem?
    @State private var imageErrorMessage: String?

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
                TextField("Address line 2", text: $addressLine2)
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
                Text("Address")
            }

            Section {
                Picker("Default tax", selection: $defaultTaxProvince) {
                    ForEach(CanadianProvince.allCases) { province in
                        Text(TaxPresetService.preset(for: province).displayName).tag(province)
                    }
                }
                TextField("Default payment terms", text: $defaultTerms, axis: .vertical)
                    .lineLimit(2...4)
            } header: {
                Text("Defaults")
            }

            Section {
                imagePickerRow(
                    title: "Logo",
                    systemImage: "photo.badge.plus",
                    path: logoImagePath,
                    selection: $selectedLogoItem
                )

                imagePickerRow(
                    title: "Signature",
                    systemImage: "signature",
                    path: signatureImagePath,
                    selection: $selectedSignatureItem
                )

                if let imageErrorMessage {
                    Text(imageErrorMessage)
                        .font(.caption)
                        .foregroundStyle(AppTheme.errorRed)
                }
            } header: {
                Text("PDF Branding")
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
        .onChange(of: selectedLogoItem) { _, newItem in
            Task {
                await savePickedImage(newItem, filenamePrefix: "logo") { path in
                    logoImagePath = path
                }
            }
        }
        .onChange(of: selectedSignatureItem) { _, newItem in
            Task {
                await savePickedImage(newItem, filenamePrefix: "signature") { path in
                    signatureImagePath = path
                }
            }
        }
    }

    private func imagePickerRow(
        title: String,
        systemImage: String,
        path: String,
        selection: Binding<PhotosPickerItem?>
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                Spacer()
                PhotosPicker(selection: selection, matching: .images) {
                    Text(path.isEmpty ? "Add" : "Replace")
                }
            }

            if let image = ImageStorageService.image(for: path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: title == "Signature" ? 76 : 92)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Remove \(title)", role: .destructive) {
                    try? ImageStorageService.deleteImage(at: path)
                    if title == "Logo" {
                        logoImagePath = ""
                    } else {
                        signatureImagePath = ""
                    }
                }
                .font(.caption)
            } else {
                Text("Optional. Appears on exported PDFs.")
                    .font(.caption)
                    .foregroundStyle(AppTheme.mutedText)
            }
        }
    }

    private func populate() {
        guard let existingProfile else { return }
        businessName = existingProfile.businessName
        ownerName = existingProfile.ownerName
        phone = existingProfile.phone
        email = existingProfile.email
        addressLine1 = existingProfile.addressLine1
        addressLine2 = existingProfile.addressLine2
        city = existingProfile.city
        province = existingProfile.province
        postalCode = existingProfile.postalCode
        taxNumber = existingProfile.taxNumber
        defaultTaxProvince = existingProfile.defaultTaxProvince
        defaultTerms = existingProfile.defaultPaymentTerms
        logoImagePath = existingProfile.logoImagePath
        signatureImagePath = existingProfile.signatureImagePath
    }

    private func save() {
        let profile = existingProfile ?? BusinessProfile()
        profile.businessName = businessName
        profile.ownerName = ownerName
        profile.phone = phone
        profile.email = email
        profile.addressLine1 = addressLine1
        profile.addressLine2 = addressLine2
        profile.city = city
        profile.provinceCode = province.code
        profile.postalCode = postalCode
        profile.taxNumber = taxNumber
        profile.logoImagePath = logoImagePath
        profile.signatureImagePath = signatureImagePath
        profile.defaultTaxProvinceCode = defaultTaxProvince.code
        profile.defaultPaymentTerms = defaultTerms
        profile.updatedAt = .now

        if existingProfile == nil {
            modelContext.insert(profile)
        }
        try? modelContext.save()
        dismiss()
    }

    @MainActor
    private func savePickedImage(
        _ item: PhotosPickerItem?,
        filenamePrefix: String,
        assignPath: @escaping (String) -> Void
    ) async {
        guard let item else { return }

        do {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                imageErrorMessage = "That image could not be loaded. Please choose another one."
                return
            }
            let path = try ImageStorageService.saveImageData(data, filenamePrefix: filenamePrefix)
            assignPath(path)
            imageErrorMessage = nil
        } catch {
            imageErrorMessage = "That image could not be saved. Please choose another one."
        }
    }
}
