import Foundation

struct PDFRenderRequest {
    var businessName: String
    var businessContactLines: [String]
    var documentType: DocumentType
    var documentNumber: String
    var issueDate: Date
    var dueDate: Date
    var clientLines: [String]
    var title: String
    var lineItems: [CalculationLineItem]
    var totals: DocumentTotals
    var amountPaid: Decimal = .zero
    var notes: String
    var terms: String
    var logoURL: URL? = nil
    var signatureURL: URL? = nil

    static func make(
        document: Document,
        businessProfile: BusinessProfile?
    ) -> PDFRenderRequest {
        let preset = TaxPresetService.preset(for: document)
        let rawAmountPaid = Decimal.dollars(from: document.amountPaidCents).clampedToNonNegative
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: document.sortedLineItems.map(\.calculationLineItem),
                discountType: document.discountType,
                discountValue: document.discountType == .percentage
                    ? Decimal(document.discountPercentage)
                    : Decimal.dollars(from: document.discountValueCents),
                taxPreset: preset,
                amountPaid: rawAmountPaid
            )
        )
        let displayedAmountPaid = min(rawAmountPaid, totals.total)
        let cleanTaxNumber = businessProfile?.taxNumber.trimmedForStorage ?? ""

        let businessLines = [
            businessProfile?.ownerName.trimmedForStorage ?? "",
            businessProfile?.singleLineAddress.trimmedForStorage ?? "",
            businessProfile?.phone.trimmedForStorage ?? "",
            businessProfile?.email.trimmedForStorage ?? "",
            cleanTaxNumber.isEmpty ? "" : "Tax #: \(cleanTaxNumber)"
        ].filter { !$0.isEmpty }

        let clientLines = [
            document.clientNameSnapshot.trimmedForStorage,
            document.clientCompanySnapshot.trimmedForStorage,
            document.clientAddressSnapshot.trimmedForStorage,
            document.clientEmailSnapshot.trimmedForStorage,
            document.clientPhoneSnapshot.trimmedForStorage
        ].filter { !$0.isEmpty }
        let cleanBusinessName = businessProfile?.businessName.trimmedForStorage ?? ""

        return PDFRenderRequest(
            businessName: cleanBusinessName.isEmpty ? "TradeBill Canada" : cleanBusinessName,
            businessContactLines: businessLines,
            documentType: document.type,
            documentNumber: document.documentNumber,
            issueDate: document.issueDate,
            dueDate: document.dueDate,
            clientLines: clientLines,
            title: document.title.trimmedForStorage,
            lineItems: document.sortedLineItems.map(\.calculationLineItem),
            totals: totals,
            amountPaid: displayedAmountPaid,
            notes: document.notes.trimmedForStorage,
            terms: document.terms.trimmedForStorage,
            logoURL: ImageStorageService.url(for: businessProfile?.logoImagePath ?? ""),
            signatureURL: ImageStorageService.url(for: businessProfile?.signatureImagePath ?? "")
        )
    }
}
