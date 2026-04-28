import SwiftData
import SwiftUI

private enum NewDocumentSheet: Identifiable {
    case estimate
    case invoice

    var id: String {
        switch self {
        case .estimate: "estimate"
        case .invoice: "invoice"
        }
    }

    var documentType: DocumentType {
        switch self {
        case .estimate: .estimate
        case .invoice: .invoice
        }
    }
}

struct HomeDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Query private var documents: [Document]
    @Query private var settings: [AppSettings]
    @Query private var purchaseStates: [PurchaseState]

    @State private var searchText = ""
    @State private var newDocumentSheet: NewDocumentSheet?
    @State private var showingPaywall = false

    private var filteredDocuments: [Document] {
        let sorted = documents.sorted { $0.updatedAt > $1.updatedAt }
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return sorted
        }
        return sorted.filter {
            $0.documentNumber.localizedCaseInsensitiveContains(searchText)
                || $0.displayClientName.localizedCaseInsensitiveContains(searchText)
                || $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var unpaidTotal: Int {
        documents
            .filter { $0.type == .invoice && $0.balanceDueCents > 0 }
            .map(\.balanceDueCents)
            .reduce(0, +)
    }

    private var draftCount: Int {
        documents.filter { $0.statusRawValue == "draft" }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                summaryCard

                HStack(spacing: 12) {
                    PrimaryButton(title: "New Estimate", systemImage: "doc.badge.plus") {
                        startNewDocument(.estimate)
                    }
                    PrimaryButton(title: "New Invoice", systemImage: "plus.square") {
                        startNewDocument(.invoice)
                    }
                }

                TextField("Search documents", text: $searchText)
                    .textFieldStyle(.roundedBorder)

                if filteredDocuments.isEmpty {
                    EmptyStateView(
                        title: "No documents yet",
                        message: "Create your first estimate or invoice and it will show up here.",
                        systemImage: "doc.text.magnifyingglass"
                    )
                } else {
                    VStack(spacing: 12) {
                        ForEach(filteredDocuments) { document in
                            NavigationLink {
                                DocumentDetailView(document: document)
                            } label: {
                                DocumentCardView(document: document)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(AppTheme.offWhite)
        .navigationTitle("TradeBill")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingPaywall = true
                } label: {
                    Image(systemName: EntitlementGate.isUnlocked(settings: settings.first, purchaseState: purchaseStates.first) ? "checkmark.seal.fill" : "lock.open")
                }
                .foregroundStyle(AppTheme.deepTurquoise)
            }
        }
        .sheet(item: $newDocumentSheet) { sheet in
            NavigationStack {
                DocumentEditorView(documentType: sheet.documentType)
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
        .task {
            syncPurchaseStateIfNeeded()
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.deepTurquoise)
                .textCase(.uppercase)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(CurrencyFormatter.string(fromCents: unpaidTotal))
                        .font(.title.bold())
                        .foregroundStyle(AppTheme.darkText)
                    Text("Unpaid invoices")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.mutedText)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(draftCount)")
                        .font(.title2.bold())
                        .foregroundStyle(AppTheme.darkText)
                    Text("Drafts")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.mutedText)
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.white, AppTheme.turquoise.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
    }

    private func startNewDocument(_ type: DocumentType) {
        syncPurchaseStateIfNeeded()
        if EntitlementGate.canCreateDocument(settings: settings.first, purchaseState: purchaseStates.first) {
            newDocumentSheet = type == .invoice ? .invoice : .estimate
        } else {
            showingPaywall = true
        }
    }

    private func syncPurchaseStateIfNeeded() {
        guard purchaseManager.hasLifetimeUnlock else { return }
        settings.first?.hasLifetimeUnlock = true
        purchaseStates.first?.hasLifetimeUnlock = true
        purchaseStates.first?.lastVerifiedAt = .now
        try? modelContext.save()
    }
}

