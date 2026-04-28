import SwiftUI

struct StatusBadge: View {
    let text: String
    var isPaid: Bool = false

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(isPaid ? AppTheme.successGreen : AppTheme.deepTurquoise)
            .background((isPaid ? AppTheme.successGreen : AppTheme.turquoise).opacity(0.12), in: Capsule())
    }
}

