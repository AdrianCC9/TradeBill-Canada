import Foundation

enum DocumentConversionService {
    static func makeInvoice(
        from estimate: Document,
        settings: AppSettings,
        issueDate: Date = .now
    ) -> Document {
        let invoiceNumber = DocumentNumberService.nextNumber(for: .invoice, settings: settings)
        let dueDate = Calendar.current.date(byAdding: .day, value: 14, to: issueDate) ?? issueDate

        let invoice = Document(
            type: .invoice,
            documentNumber: invoiceNumber,
            client: estimate.client,
            title: estimate.title,
            jobAddress: estimate.jobAddress,
            issueDate: issueDate,
            dueDate: dueDate,
            statusRawValue: InvoiceStatus.unpaid.rawValue,
            subtotalCents: estimate.subtotalCents,
            discountType: estimate.discountType,
            discountValueCents: estimate.discountValueCents,
            discountPercentage: estimate.discountPercentage,
            taxProvinceCode: estimate.taxProvinceCode,
            taxLabel: estimate.taxLabel,
            taxRatePercent: estimate.taxRatePercent,
            taxAmountCents: estimate.taxAmountCents,
            amountPaidCents: 0,
            totalCents: estimate.totalCents,
            balanceDueCents: estimate.totalCents,
            notes: estimate.notes,
            terms: estimate.terms,
            convertedFromEstimateId: estimate.id
        )

        invoice.clientNameSnapshot = estimate.clientNameSnapshot
        invoice.clientCompanySnapshot = estimate.clientCompanySnapshot
        invoice.clientEmailSnapshot = estimate.clientEmailSnapshot
        invoice.clientPhoneSnapshot = estimate.clientPhoneSnapshot
        invoice.clientAddressSnapshot = estimate.clientAddressSnapshot
        invoice.lineItems = estimate.sortedLineItems.enumerated().map { index, item in
            LineItem(
                itemDescription: item.itemDescription,
                quantity: item.quantity,
                unitPriceCents: item.unitPriceCents,
                sortOrder: index,
                document: invoice
            )
        }

        estimate.statusRawValue = EstimateStatus.converted.rawValue
        estimate.updatedAt = .now
        DocumentNumberService.consumeNextNumber(for: .invoice, settings: settings)
        settings.freeDocumentsCreated += 1
        settings.updatedAt = .now

        return invoice
    }
}

