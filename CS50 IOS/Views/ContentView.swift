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

                //Button {
                //    CreateReport()
               // } label: {
               //     Text(isSaving ? "Saving..." : "Create Report")
              //  }
              //  .disabled(isSaving)

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
                Label("Create Report", systemImage: "hammer")
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

    struct FormView: View {
        @State private var Title: String = ""
        @State private var IncidentDescription: String = ""
        @State private var date = Date()
        
        var body: some View {
            NavigationStack {
                Form {
                    Section("ICE Activity Report") {
                        TextField("Report Title", text: $Title)
                        ZStack(alignment: .topLeading) {
                            if IncidentDescription.isEmpty {
                                Text("Describe incident with as much detail as possible.")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                            }
                            TextEditor(text: $IncidentDescription)
                                .frame(minHeight: 120)
                        }
                        DatePicker(
                            "Date",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                    }
                }
                .navigationTitle("New Report")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack
        {
            ContentView()
        }
    }
}
