import PDFKit
import SwiftData
import SwiftUI
import StoreKit

struct PDFPreviewView: View {
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @AppStorage("hasRequestedReviewAfterPDFShare") private var hasRequestedReviewAfterPDFShare = false
    @Query private var businessProfiles: [BusinessProfile]
    @Query private var settings: [AppSettings]
    @Query private var purchaseStates: [PurchaseState]

    let document: Document

    @State private var pdfData: Data?
    @State private var pdfURL: URL?
    @State private var showingPaywall = false

    private var canExport: Bool {
        EntitlementGate.canExportPDF(settings: settings.first, purchaseState: purchaseStates.first)
            || purchaseManager.hasLifetimeUnlock
    }

    private var isMissingBusinessName: Bool {
        businessProfiles.first?.businessName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != false
    }

    var body: some View {
        VStack(spacing: 0) {
            if let pdfData {
                PDFKitPreview(data: pdfData)
            } else {
                ProgressView("Generating PDF")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack(spacing: 10) {
                if isMissingBusinessName {
                    Label("Tip: add your business name in Settings before sending this PDF.", systemImage: "exclamationmark.triangle")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.warningOrange)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let pdfURL, canExport {
                    ShareLink(item: pdfURL) {
                        Label("Share or Save PDF", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.turquoise)
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            requestReviewAfterShareIntentIfNeeded()
                        }
                    )
                } else {
                    Button {
                        showingPaywall = true
                    } label: {
                        Label("Unlock PDF Export", systemImage: "lock")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.turquoise)
                }
            }
            .padding(16)
            .background(.white)
        }
        .navigationTitle("PDF Preview")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            generate()
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }

    private func generate() {
        let request = PDFRenderRequest.make(document: document, businessProfile: businessProfiles.first)
        let data = PDFRenderService.render(request: request)
        pdfData = data
        pdfURL = try? PDFRenderService.writeTemporaryPDF(
            request: request,
            filename: PDFFilenameService.filename(for: document)
        )
    }

    private func requestReviewAfterShareIntentIfNeeded() {
        guard !hasRequestedReviewAfterPDFShare else { return }
        hasRequestedReviewAfterPDFShare = true
        requestReview()
    }
}

private struct PDFKitPreview: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.backgroundColor = UIColor.systemGroupedBackground
        view.document = PDFDocument(data: data)
        return view
    }

    func updateUIView(_ view: PDFView, context: Context) {
        view.document = PDFDocument(data: data)
    }
}
