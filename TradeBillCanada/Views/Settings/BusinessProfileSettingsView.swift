import SwiftData
import SwiftUI

struct BusinessProfileSettingsView: View {
    @Query private var businessProfiles: [BusinessProfile]

    var body: some View {
        BusinessSetupView(existingProfile: businessProfiles.first)
    }
}

