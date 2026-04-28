import SwiftUI

struct DocumentCardView: View {
    let document: Document

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(document.documentNumber)
                        .font(.headline)
                        .foregroundStyle(AppTheme.darkText)
                    Text(document.displayClientName)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.mutedText)
                }

                Spacer()

                Text(CurrencyFormatter.string(fromCents: document.totalCents))
                    .font(.headline)
                    .foregroundStyle(AppTheme.darkText)
            }

            HStack {
                Text("Due \(DateFormatterFactory.shortDate.string(from: document.dueDate))")
                    .font(.caption)
                    .foregroundStyle(AppTheme.mutedText)

                Spacer()

                StatusBadge(
                    text: document.statusDisplayName,
                    isPaid: document.statusRawValue == InvoiceStatus.paid.rawValue
                )
            }
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppTheme.borderGray, lineWidth: 1)
        }
    }
}

