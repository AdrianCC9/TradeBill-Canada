import PDFKit
import SwiftData
import SwiftUI

struct PDFPreviewView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
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

    var body: some View {
        VStack(spacing: 0) {
            if let pdfData {
                PDFKitPreview(data: pdfData)
            } else {
                ProgressView("Generating PDF")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack(spacing: 10) {
                if let pdfURL, canExport {
                    ShareLink(item: pdfURL) {
                        Label("Share PDF", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.turquoise)
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

