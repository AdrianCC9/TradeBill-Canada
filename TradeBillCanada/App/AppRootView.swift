import SwiftData
import SwiftUI

struct AppRootView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("skippedBusinessSetup") private var skippedBusinessSetup = false
    @Query private var businessProfiles: [BusinessProfile]

    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView {
                    hasSeenOnboarding = true
                }
            } else if businessProfiles.isEmpty && !skippedBusinessSetup {
                NavigationStack {
                    BusinessSetupView(onSkip: {
                        skippedBusinessSetup = true
                    })
                }
            } else {
                MainTabView()
            }
        }
        .task {
            SeedData.ensureDefaults(in: modelContext)
        }
    }
}

private struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeDashboardView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                ClientListView()
            }
            .tabItem {
                Label("Clients", systemImage: "person.2")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
        .tint(AppTheme.deepTurquoise)
    }
}

