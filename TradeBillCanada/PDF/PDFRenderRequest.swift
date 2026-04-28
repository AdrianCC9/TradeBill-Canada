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
    var notes: String
    var terms: String

    static func make(
        document: Document,
        businessProfile: BusinessProfile?
    ) -> PDFRenderRequest {
        let preset = TaxPresetService.preset(matchingProvinceCode: document.taxProvinceCode)
        let totals = CalculationService.calculate(
            CalculationInput(
                lineItems: document.sortedLineItems.map(\.calculationLineItem),
                discountType: document.discountType,
                discountValue: document.discountType == .percentage
                    ? Decimal(document.discountPercentage)
                    : Decimal.dollars(from: document.discountValueCents),
                taxPreset: preset,
                amountPaid: Decimal.dollars(from: document.amountPaidCents)
            )
        )

        let businessLines = [
            businessProfile?.ownerName ?? "",
            businessProfile?.singleLineAddress ?? "",
            businessProfile?.phone ?? "",
            businessProfile?.email ?? "",
            businessProfile?.taxNumber.isEmpty == false ? "Tax #: \(businessProfile?.taxNumber ?? "")" : ""
        ].filter { !$0.isEmpty }

        let clientLines = [
            document.clientNameSnapshot,
            document.clientCompanySnapshot,
            document.clientAddressSnapshot,
            document.clientEmailSnapshot,
            document.clientPhoneSnapshot
        ].filter { !$0.isEmpty }

        return PDFRenderRequest(
            businessName: businessProfile?.businessName.isEmpty == false ? businessProfile?.businessName ?? "TradeBill Canada" : "TradeBill Canada",
            businessContactLines: businessLines,
            documentType: document.type,
            documentNumber: document.documentNumber,
            issueDate: document.issueDate,
            dueDate: document.dueDate,
            clientLines: clientLines,
            title: document.title,
            lineItems: document.sortedLineItems.map(\.calculationLineItem),
            totals: totals,
            notes: document.notes,
            terms: document.terms
        )
    }
}

