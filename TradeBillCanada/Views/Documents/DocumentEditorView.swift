import SwiftData
import SwiftUI

private struct LineItemDraft: Identifiable {
    var id = UUID()
    var description = ""
    var quantity = "1"
    var unitPrice = ""

    var calculationLineItem: CalculationLineItem {
        CalculationLineItem(
            description: description,
            quantity: quantity.decimalValue,
            unitPrice: unitPrice.decimalValue
        )
    }
}

struct DocumentEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var clients: [Client]
    @Query private var settings: [AppSettings]
    @Query private var businessProfiles: [BusinessProfile]

    let documentType: DocumentType
    let existingDocument: Document?

    @State private var selectedClientID: UUID?
    @State private var title = ""
    @State private var jobAddress = ""
    @State private var issueDate = Date()
    @State private var dueDate = Calendar.current.date(byAdding: .day, value: 14, to: .now) ?? .now
    @State private var lineItems = [LineItemDraft(description: "Service", quantity: "1", unitPrice: "")]
    @State private var discountType = DiscountType.none
    @State private var discountValue = ""
    @State private var taxPresetID = CanadianProvince.ON.code
    @State private var amountPaid = ""
    @State private var notes = ""
    @State private var terms = "Payment due within 14 days."

    init(documentType: DocumentType, existingDocument: Document? = nil) {
        self.documentType = documentType
        self.existingDocument = existingDocument
    }

    private var selectedClient: Client? {
        guard let selectedClientID else { return nil }
        return clients.first { $0.id == selectedClientID }
    }

    private var taxOptions: [TaxPreset] {
        [TaxPresetService.noTax] + TaxPresetService.provincePresets
    }

    private var selectedTaxPreset: TaxPreset {
        taxOptions.first { $0.id == taxPresetID } ?? TaxPresetService.noTax
    }

    private var totals: DocumentTotals {
        CalculationService.calculate(
            CalculationInput(
                lineItems: lineItems.map(\.calculationLineItem),
                discountType: discountType,
                discountValue: discountValue.decimalValue,
                taxPreset: selectedTaxPreset,
                amountPaid: amountPaid.decimalValue
            )
        )
    }

    var body: some View {
        Form {
            Section("Client") {
                Picker("Client", selection: $selectedClientID) {
                    Text("No client").tag(Optional<UUID>.none)
                    ForEach(clients.sorted { $0.displayName < $1.displayName }) { client in
                        Text(client.displayName).tag(Optional(client.id))
                    }
                }
            }

            Section("Details") {
                TextField("Job or service title", text: $title)
                TextField("Job address (optional)", text: $jobAddress)
                DatePicker("Issue date", selection: $issueDate, displayedComponents: .date)
                DatePicker("Due date", selection: $dueDate, displayedComponents: .date)
            }

            Section("Line Items") {
                ForEach($lineItems) { $item in
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Description", text: $item.description)
                        HStack {
                            TextField("Qty", text: $item.quantity)
                                .keyboardType(.decimalPad)
                            MoneyTextField(title: "Rate", text: $item.unitPrice)
                            Text(CurrencyFormatter.string(from: item.calculationLineItem.lineTotal))
                                .font(.subheadline.weight(.semibold))
                                .frame(width: 92, alignment: .trailing)
                        }
                    }
                }
                .onDelete { offsets in
                    lineItems.remove(atOffsets: offsets)
                }

                Button {
                    lineItems.append(LineItemDraft(description: "", quantity: "1", unitPrice: ""))
                } label: {
                    Label("Add line item", systemImage: "plus.circle")
                }
            }

            Section("Discount and Tax") {
                Picker("Discount", selection: $discountType) {
                    ForEach(DiscountType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                if discountType != .none {
                    MoneyTextField(title: discountType == .percentage ? "Discount %" : "Discount amount", text: $discountValue)
                }

                Picker("Tax", selection: $taxPresetID) {
                    ForEach(taxOptions) { preset in
                        Text(preset.displayName).tag(preset.id)
                    }
                }
            }

            Section("Payment") {
                MoneyTextField(title: documentType == .invoice ? "Amount paid" : "Deposit / paid amount", text: $amountPaid)
            }

            Section("Notes and Terms") {
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(2...5)
                TextField("Terms", text: $terms, axis: .vertical)
                    .lineLimit(2...5)
            }

            Section("Totals") {
                totalRow("Subtotal", totals.subtotal)
                if totals.discountAmount > .zero {
                    totalRow("Discount", -totals.discountAmount)
                }
                ForEach(totals.taxLines) { taxLine in
                    totalRow("\(taxLine.label) \(taxLine.ratePercent)%", taxLine.amount)
                }
                totalRow("Total", totals.total, isBold: true)
                totalRow("Balance Due", totals.balanceDue, isBold: true)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.offWhite)
        .navigationTitle(existingDocument == nil ? "New \(documentType.displayName)" : "Edit \(documentType.displayName)")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(lineItems.allSatisfy { $0.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
            }
        }
        .onAppear(perform: populate)
    }

    @ViewBuilder
    private func totalRow(_ label: String, _ amount: Decimal, isBold: Bool = false) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(CurrencyFormatter.string(from: amount))
        }
        .font(isBold ? .headline : .body)
    }

    private func populate() {
        if let existingDocument {
            selectedClientID = existingDocument.client?.id
            title = existingDocument.title
            jobAddress = existingDocument.jobAddress
            issueDate = existingDocument.issueDate
            dueDate = existingDocument.dueDate
            lineItems = existingDocument.sortedLineItems.map {
                LineItemDraft(
                    description: $0.itemDescription,
                    quantity: NSDecimalNumber(decimal: Decimal($0.quantity)).stringValue,
                    unitPrice: NSDecimalNumber(decimal: Decimal.dollars(from: $0.unitPriceCents)).stringValue
                )
            }
            if lineItems.isEmpty {
                lineItems = [LineItemDraft(description: "Service", quantity: "1", unitPrice: "")]
            }
            discountType = existingDocument.discountType
            discountValue = existingDocument.discountType == .percentage
                ? NSDecimalNumber(value: existingDocument.discountPercentage).stringValue
                : NSDecimalNumber(decimal: Decimal.dollars(from: existingDocument.discountValueCents)).stringValue
            taxPresetID = existingDocument.taxProvinceCode ?? TaxPresetService.noTax.id
            amountPaid = NSDecimalNumber(decimal: Decimal.dollars(from: existingDocument.amountPaidCents)).stringValue
            notes = existingDocument.notes
            terms = existingDocument.terms
            return
        }

        guard let profile = businessProfiles.first else { return }
        taxPresetID = profile.defaultTaxProvinceCode
        terms = profile.defaultPaymentTerms
    }

    private func save() {
        let appSettings = settings.first ?? AppSettings()
        if settings.isEmpty {
            modelContext.insert(appSettings)
        }

        let isNewDocument = existingDocument == nil
        let document = existingDocument ?? Document(
            type: documentType,
            documentNumber: DocumentNumberService.nextNumber(for: documentType, settings: appSettings)
        )

        document.client = selectedClient
        document.updateClientSnapshot()
        document.title = title
        document.jobAddress = jobAddress
        document.issueDate = issueDate
        document.dueDate = dueDate
        document.subtotalCents = totals.subtotal.cents
        document.discountType = discountType
        document.discountValueCents = discountType == .fixed ? discountValue.decimalValue.cents : 0
        document.discountPercentage = discountType == .percentage ? NSDecimalNumber(decimal: discountValue.decimalValue).doubleValue : 0
        document.taxProvinceCode = selectedTaxPreset.provinceCode
        document.taxLabel = selectedTaxPreset.pdfLabel
        document.taxRatePercent = NSDecimalNumber(decimal: selectedTaxPreset.combinedRatePercent).doubleValue
        document.taxAmountCents = totals.taxAmount.cents
        document.amountPaidCents = amountPaid.decimalValue.cents
        document.totalCents = totals.total.cents
        document.balanceDueCents = totals.balanceDue.cents
        document.notes = notes
        document.terms = terms
        document.statusRawValue = statusAfterSave(for: documentType, totals: totals)
        document.updatedAt = .now

        document.lineItems.forEach { modelContext.delete($0) }
        document.lineItems = lineItems.enumerated().map { index, item in
            LineItem(
                itemDescription: item.description,
                quantity: NSDecimalNumber(decimal: item.quantity.decimalValue).doubleValue,
                unitPriceCents: item.unitPrice.decimalValue.cents,
                sortOrder: index,
                document: document
            )
        }

        if isNewDocument {
            modelContext.insert(document)
            DocumentNumberService.consumeNextNumber(for: documentType, settings: appSettings)
            appSettings.freeDocumentsCreated += 1
            appSettings.updatedAt = .now
        }
        try? modelContext.save()
        dismiss()
    }

    private func statusAfterSave(for type: DocumentType, totals: DocumentTotals) -> String {
        switch type {
        case .estimate:
            return EstimateStatus.draft.rawValue
        case .invoice:
            if totals.balanceDue <= .zero { return InvoiceStatus.paid.rawValue }
            if amountPaid.decimalValue > .zero { return InvoiceStatus.partiallyPaid.rawValue }
            return InvoiceStatus.unpaid.rawValue
        }
    }
}
