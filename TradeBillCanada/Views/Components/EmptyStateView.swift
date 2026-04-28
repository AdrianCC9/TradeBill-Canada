import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    var systemImage: String = "doc.text"

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(AppTheme.turquoise)
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.darkText)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.mutedText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

