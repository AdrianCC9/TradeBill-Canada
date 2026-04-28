import SwiftData
import SwiftUI

struct DocumentDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]

    let document: Document
    @State private var showingEditor = false

    private var computedTotals: DocumentTotals {
        CalculationService.calculate(
            CalculationInput(
                lineItems: document.sortedLineItems.map(\.calculationLineItem),
                discountType: document.discountType,
                discountValue: document.discountType == .percentage
                    ? Decimal(document.discountPercentage)
                    : Decimal.dollars(from: document.discountValueCents),
                taxPreset: TaxPresetService.preset(for: document),
                amountPaid: Decimal.dollars(from: document.amountPaidCents)
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header

                VStack(alignment: .leading, spacing: 10) {
                    Text("Line Items")
                        .font(.headline)
                    ForEach(document.sortedLineItems) { item in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.itemDescription)
                                Text("Qty \(item.quantity.formatted()) x \(CurrencyFormatter.string(fromCents: item.unitPriceCents))")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.mutedText)
                            }
                            Spacer()
                            Text(CurrencyFormatter.string(fromCents: item.lineTotalCents))
                        }
                        Divider()
                    }
                }
                .cardStyle()

                totalsCard

                VStack(spacing: 12) {
                    Button {
                        showingEditor = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    NavigationLink {
                        PDFPreviewView(document: document)
                    } label: {
                        Label("Preview PDF", systemImage: "doc.richtext")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.turquoise)

                    if document.type == .estimate && document.statusRawValue != EstimateStatus.converted.rawValue {
                        Button {
                            convertToInvoice()
                        } label: {
                            Label("Convert to Invoice", systemImage: "arrow.triangle.2.circlepath")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }

                    if document.type == .invoice && document.balanceDueCents > 0 {
                        Button {
                            markPaid()
                        } label: {
                            Label("Mark as Paid", systemImage: "checkmark.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding(20)
        }
        .background(AppTheme.offWhite)
        .navigationTitle(document.documentNumber)
        .sheet(isPresented: $showingEditor) {
            NavigationStack {
                DocumentEditorView(documentType: document.type, existingDocument: document)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(document.type.displayName)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.deepTurquoise)
                    Text(document.displayClientName)
                        .font(.title2.bold())
                        .foregroundStyle(AppTheme.darkText)
                }
                Spacer()
                StatusBadge(text: document.statusDisplayName, isPaid: document.statusRawValue == InvoiceStatus.paid.rawValue)
            }

            if !document.title.isEmpty {
                Text(document.title)
                    .foregroundStyle(AppTheme.mutedText)
            }

            HStack {
                Label(DateFormatterFactory.shortDate.string(from: document.issueDate), systemImage: "calendar")
                Spacer()
                Label("Due \(DateFormatterFactory.shortDate.string(from: document.dueDate))", systemImage: "clock")
            }
            .font(.caption)
            .foregroundStyle(AppTheme.mutedText)
        }
        .cardStyle()
    }

    private var totalsCard: some View {
        VStack(spacing: 10) {
            amountRow("Subtotal", document.subtotalCents)
            if document.discountType != .none {
                amountRow("Discount", -computedTotals.discountAmount.cents)
            }
            amountRow(document.taxLabel, document.taxAmountCents)
            amountRow("Paid", -document.amountPaidCents)
            Divider()
            amountRow("Total", document.totalCents, isBold: true)
            amountRow("Balance Due", document.balanceDueCents, isBold: true)
        }
        .cardStyle()
    }

    private func amountRow(_ label: String, _ cents: Int, isBold: Bool = false) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(CurrencyFormatter.string(fromCents: cents))
        }
        .font(isBold ? .headline : .body)
    }

    private func convertToInvoice() {
        let appSettings = settings.first ?? AppSettings()
        if settings.isEmpty {
            modelContext.insert(appSettings)
        }
        let invoice = DocumentConversionService.makeInvoice(from: document, settings: appSettings)
        modelContext.insert(invoice)
        try? modelContext.save()
    }

    private func markPaid() {
        document.amountPaidCents = document.totalCents
        document.balanceDueCents = 0
        document.statusRawValue = InvoiceStatus.paid.rawValue
        document.updatedAt = .now
        try? modelContext.save()
    }
}

private extension View {
    func cardStyle() -> some View {
        padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(AppTheme.borderGray, lineWidth: 1)
            }
    }
}
