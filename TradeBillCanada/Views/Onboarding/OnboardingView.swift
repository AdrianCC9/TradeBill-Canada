import SwiftUI

struct OnboardingView: View {
    var onGetStarted: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 32)

            ZStack {
                Circle()
                    .fill(AppTheme.turquoise.opacity(0.12))
                    .frame(width: 150, height: 150)
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 62, weight: .semibold))
                    .foregroundStyle(AppTheme.deepTurquoise)
            }

            VStack(spacing: 12) {
                Text("TradeBill Canada")
                    .font(.largeTitle.bold())
                    .foregroundStyle(AppTheme.darkText)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.85)

                Text("Create professional Canadian estimates and invoices in seconds.")
                    .font(.title3)
                    .foregroundStyle(AppTheme.mutedText)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                Text("No login. No subscription. Built for small service businesses.")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppTheme.deepTurquoise)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
            }
            .frame(maxWidth: 340)

            Spacer()

            PrimaryButton(title: "Get Started", systemImage: "arrow.right") {
                onGetStarted()
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.offWhite.ignoresSafeArea())
    }
}
