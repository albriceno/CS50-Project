////
///
import SwiftUI

struct ContentView: View {

    @State private var isSaving = false
    @State private var saveResultMessage: String?

    var body: some View {
        TabView {
            // 🗺️ MAP TAB – uses your partner's view
            MapKitContentView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            // 🧪 DEBUG / BACKEND TEST TAB
            VStack(spacing: 20) {
                Text("ICE Activity Tracker - Backend Test")
                    .font(.headline)

                Button {
                    testCreateDummyReport()
                } label: {
                    Text(isSaving ? "Saving..." : "Create Dummy Report")
                }
                .disabled(isSaving)

                if let message = saveResultMessage {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .tabItem {
                Label("Debug", systemImage: "hammer")
            }

            // 📚 RESOURCES TAB
            NavigationSplitView {
                List {
                    NavigationLink {
                        ResourcesView()
                    } label: {
                        Label("Resources", systemImage: "book")
                            .font(.headline)
                    }
                }
            } detail: {
                Text("Select a resource")
            }
            .tabItem {
                Label("Resources", systemImage: "book")
            }
        }
    }

    private func testCreateDummyReport() {
        isSaving = true
        saveResultMessage = nil

        // Example coordinates: somewhere in the US
        let testLat = 40.7128
        let testLng = -74.0060

        ReportService.shared.submitReport(
            lat: testLat,
            lng: testLng,
            description: "Test ICE report from ContentView"
        ) { result in
            DispatchQueue.main.async {
                self.isSaving = false
                switch result {
                case .success:
                    self.saveResultMessage = "Report saved! Check Firestore 'reports' collection."
                case .failure(let error):
                    self.saveResultMessage = "Failed to save report: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
