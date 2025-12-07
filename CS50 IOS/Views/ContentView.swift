////
///
import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    
    // Location manager to read device location
    @StateObject private var locationManager = LocationManager()
=======
>>>>>>> 7d059c8de9f0a16e686772f0a55dd9e83970cf00
    
        
    var body: some View {
        TabView {
            // MAP TAB
            MapKitContentView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
<<<<<<< HEAD
                        
=======
>>>>>>> 7d059c8de9f0a16e686772f0a55dd9e83970cf00
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
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ZStack {
                ContentView()
            }
        }
    }
}
