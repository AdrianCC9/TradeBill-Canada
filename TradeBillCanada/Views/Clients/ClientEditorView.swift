import SwiftData
import SwiftUI

struct ClientEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let client: Client?
    var onSave: ((Client) -> Void)?

    @State private var name = ""
    @State private var companyName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var addressLine1 = ""
    @State private var addressLine2 = ""
    @State private var city = ""
    @State private var province = CanadianProvince.ON
    @State private var postalCode = ""
    @State private var notes = ""
    @State private var saveErrorMessage: String?

    var body: some View {
        Form {
            Section("Client") {
                TextField("Name", text: $name)
                TextField("Company (optional)", text: $companyName)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }

            Section("Address") {
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
            }

            Section("Notes") {
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(2...5)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.offWhite)
        .navigationTitle(client == nil ? "New Client" : "Edit Client")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .alert(
            "Couldn’t save client",
            isPresented: Binding(
                get: { saveErrorMessage != nil },
                set: { if !$0 { saveErrorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveErrorMessage ?? "Please try again.")
        }
        .onAppear(perform: populate)
    }

    private func populate() {
        guard let client else { return }
        name = client.name
        companyName = client.companyName
        phone = client.phone
        email = client.email
        addressLine1 = client.addressLine1
        addressLine2 = client.addressLine2
        city = client.city
        province = CanadianProvince.allCases.first { $0.code == client.provinceCode } ?? .ON
        postalCode = client.postalCode
        notes = client.notes
    }

    private func save() {
        let savedClient = client ?? Client()
        savedClient.name = name
        savedClient.companyName = companyName
        savedClient.phone = phone
        savedClient.email = email
        savedClient.addressLine1 = addressLine1
        savedClient.addressLine2 = addressLine2
        savedClient.city = city
        savedClient.provinceCode = province.code
        savedClient.postalCode = postalCode
        savedClient.notes = notes
        savedClient.updatedAt = .now

        if client == nil {
            modelContext.insert(savedClient)
        }

        do {
            try modelContext.save()
            onSave?(savedClient)
            dismiss()
        } catch {
            saveErrorMessage = "That client could not be saved. Please try again."
        }
    }
}
