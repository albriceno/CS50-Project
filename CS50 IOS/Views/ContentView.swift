////
///
import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    
    @State private var isSaving = false
    @State private var saveResultMessage: String?
    
    // For collecting description and  coordinates
    @State private var descriptionText: String = ""
    @State private var showManualLocationSheet: Bool = false
    @State private var selectedLat: Double?
    @State private var selectedLng: Double?
    
    // Manual entry strings for the sheet
    @State private var selectedLatString: String = ""
    @State private var selectedLngString: String = ""
    
    // Location manager to read device location
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        TabView {
            // MAP TAB
            MapKitContentView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            // DEBUG / BACKEND TEST TAB
            VStack(spacing: 16) {
                Text("ICE Activity Tracker - Backend Test")
                    .font(.headline)


                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextEditor(text: $descriptionText)
                        .frame(minHeight: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2))
                        )
                        .accessibilityLabel("Report description")
                }
                
                Button {
                    handleCreateReportTap()
                } label: {
                    Text(isSaving ? "Saving..." : "Create Report")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isSaving || descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                if let message = saveResultMessage {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
                
                Spacer()
            }
            .padding()
            .tabItem {
                Label("Create Report", systemImage: "hammer")
            }
            .sheet(isPresented: $showManualLocationSheet) {
                NavigationView {
                    Form {
                        Section(header: Text("Enter Location")) {
                            TextField("Latitude", text: $selectedLatString)
                                .keyboardType(.numbersAndPunctuation)
                            TextField("Longitude", text: $selectedLngString)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        Section(footer: Text("Location permission is off or unavailable. Enter coordinates manually for now.")) {
                            EmptyView()
                        }
                    }
                    .navigationTitle("Manual Location")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showManualLocationSheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Submit") { submitManualLocation() }
                        }
                    }
                }
            }
            
            // RESOURCES TAB
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
        // REPORTS TAB
            ReportsTabView()
                .tabItem {
                    Label("Reports", systemImage: "list.bullet")
                }
        }
    }
    
    // FORM
    private func handleCreateReportTap() {
        // Prefer device location if authorized and available
        let tempManager = CLLocationManager()
        let status = tempManager.authorizationStatus
        let center = locationManager.region.center
        
        let hasValidDeviceLocation =
        (status == .authorizedWhenInUse || status == .authorizedAlways) &&
        !center.latitude.isZero && !center.longitude.isZero
        
        if hasValidDeviceLocation {
            submitReport(lat: center.latitude, lng: center.longitude, description: descriptionText)
        } else {
            // Prompt manual entry
            selectedLatString = ""
            selectedLngString = ""
            showManualLocationSheet = true
        }
    }
    
    private func submitManualLocation() {
        guard
            let lat = Double(selectedLatString.trimmingCharacters(in: .whitespacesAndNewlines)),
            let lng = Double(selectedLngString.trimmingCharacters(in: .whitespacesAndNewlines))
        else {
            saveResultMessage = "Please enter valid numeric latitude and longitude."
            return
        }
        showManualLocationSheet = false
        submitReport(lat: lat, lng: lng, description: descriptionText)
    }
    
    private func submitReport(lat: Double, lng: Double, description: String) {
        isSaving = true
        saveResultMessage = nil
        
        ReportService.shared.submitReport(lat: lat, lng: lng, description: description) { result in
            DispatchQueue.main.async {
                self.isSaving = false
                switch result {
                case .success:
                    self.saveResultMessage = "Report created successfully."
                    // Optionally clear description after success
                    self.descriptionText = ""
                case .failure(let error):
                    self.saveResultMessage = "Failed to create report: \(error.localizedDescription)"
                }
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
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ZStack {
                ContentView()
            }
        }
    }
}
