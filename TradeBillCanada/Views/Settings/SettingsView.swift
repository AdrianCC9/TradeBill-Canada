import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Query private var businessProfiles: [BusinessProfile]
    @Query private var settings: [AppSettings]
    @Query private var purchaseStates: [PurchaseState]

    @State private var showingBusinessSetup = false
    @State private var showingPaywall = false

    private var isUnlocked: Bool {
        EntitlementGate.isUnlocked(settings: settings.first, purchaseState: purchaseStates.first)
            || purchaseManager.hasLifetimeUnlock
    }

    var body: some View {
        List {
            Section("Business") {
                Button {
                    showingBusinessSetup = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(businessProfiles.first?.businessName.isEmpty == false ? businessProfiles.first?.businessName ?? "Business Profile" : "Business Profile")
                                .foregroundStyle(AppTheme.darkText)
                            Text("Logo, tax number, default province, and terms")
                                .font(.caption)
                                .foregroundStyle(AppTheme.mutedText)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(AppTheme.mutedText)
                    }
                }
            }

            Section("Unlock") {
                HStack {
                    Label(isUnlocked ? "Lifetime access unlocked" : "Free plan", systemImage: isUnlocked ? "checkmark.seal.fill" : "doc.text")
                    Spacer()
                    if !isUnlocked {
                        Text("\(settings.first?.freeDocumentsCreated ?? 0)/3 used")
                            .foregroundStyle(AppTheme.mutedText)
                    }
                }

                if !isUnlocked {
                    Button("Unlock unlimited documents") {
                        showingPaywall = true
                    }
                }

                Button("Restore Purchase") {
                    Task {
                        await purchaseManager.restorePurchases()
                        persistUnlockIfNeeded()
                    }
                }
            }

            Section("Tax Disclaimer") {
                Text("Tax calculations are provided for convenience only. Users are responsible for confirming applicable tax requirements.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.mutedText)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.offWhite)
        .navigationTitle("Settings")
        .sheet(isPresented: $showingBusinessSetup) {
            NavigationStack {
                BusinessSetupView(existingProfile: businessProfiles.first)
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }

    private func persistUnlockIfNeeded() {
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
}
