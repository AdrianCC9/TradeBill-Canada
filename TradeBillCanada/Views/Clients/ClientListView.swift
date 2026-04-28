import SwiftData
import SwiftUI

struct ClientListView: View {
    @Query private var clients: [Client]
    @State private var showingEditor = false
    @State private var searchText = ""

    private var filteredClients: [Client] {
        let sorted = clients.sorted { $0.displayName < $1.displayName }
        guard !searchText.isEmpty else { return sorted }
        return sorted.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText)
                || $0.email.localizedCaseInsensitiveContains(searchText)
                || $0.phone.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            if filteredClients.isEmpty {
                EmptyStateView(
                    title: "No clients yet",
                    message: "Add clients once, then reuse them on estimates and invoices.",
                    systemImage: "person.crop.circle.badge.plus"
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else {
                ForEach(filteredClients) { client in
                    NavigationLink {
                        ClientEditorView(client: client)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(client.displayName)
                                .font(.headline)
                            if !client.email.isEmpty {
                                Text(client.email)
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.mutedText)
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .scrollContentBackground(.hidden)
        .background(AppTheme.offWhite)
        .navigationTitle("Clients")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingEditor = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingEditor) {
            NavigationStack {
                ClientEditorView(client: nil)
            }
        }
    }
}

