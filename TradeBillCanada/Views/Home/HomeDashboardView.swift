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

private enum DocumentFilter: String, CaseIterable, Identifiable {
    case all
    case estimates
    case invoices
    case unpaid
    case drafts
    case overdue

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .all: "All"
        case .estimates: "Estimates"
        case .invoices: "Invoices"
        case .unpaid: "Unpaid"
        case .drafts: "Drafts"
        case .overdue: "Overdue"
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
    @State private var selectedFilter = DocumentFilter.all

    private var filteredDocuments: [Document] {
        let sorted = documents.sorted { $0.updatedAt > $1.updatedAt }
        let filteredByType = sorted.filter(matchesSelectedFilter)
        let cleanSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanSearch.isEmpty else {
            return filteredByType
        }
        return filteredByType.filter {
            $0.documentNumber.localizedCaseInsensitiveContains(cleanSearch)
                || $0.displayClientName.localizedCaseInsensitiveContains(cleanSearch)
                || $0.title.localizedCaseInsensitiveContains(cleanSearch)
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

                filterChips

                if filteredDocuments.isEmpty {
                    EmptyStateView(
                        title: documents.isEmpty ? "No documents yet" : "No matching documents",
                        message: documents.isEmpty ? "Create your first estimate or invoice and it will show up here." : "Try another search or filter.",
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
        .navigationTitle("TradeBill Canada")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingPaywall = true
                } label: {
                    Image(systemName: EntitlementGate.isUnlocked(settings: settings.first, purchaseState: purchaseStates.first) ? "checkmark.seal.fill" : "lock.fill")
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

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(DocumentFilter.allCases) { filter in
                    Button {
                        selectedFilter = filter
                    } label: {
                        Text(filter.displayName)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .foregroundStyle(selectedFilter == filter ? .white : AppTheme.deepTurquoise)
                            .background(
                                selectedFilter == filter ? AppTheme.turquoise : .white,
                                in: Capsule()
                            )
                            .overlay {
                                Capsule()
                                    .stroke(AppTheme.borderGray, lineWidth: selectedFilter == filter ? 0 : 1)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
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
        let appSettings = settings.first ?? AppSettings()
        if settings.isEmpty { modelContext.insert(appSettings) }
        appSettings.hasLifetimeUnlock = true

        let purchaseState = purchaseStates.first ?? PurchaseState()
        if purchaseStates.isEmpty { modelContext.insert(purchaseState) }
        purchaseState.hasLifetimeUnlock = true
        purchaseState.lastVerifiedAt = .now
        try? modelContext.save()
    }

    private func matchesSelectedFilter(_ document: Document) -> Bool {
        switch selectedFilter {
        case .all:
            true
        case .estimates:
            document.type == .estimate
        case .invoices:
            document.type == .invoice
        case .unpaid:
            document.type == .invoice && document.balanceDueCents > 0
        case .drafts:
            document.statusRawValue == EstimateStatus.draft.rawValue || document.statusRawValue == InvoiceStatus.draft.rawValue
        case .overdue:
            document.isOverdue
        }
    }
}
