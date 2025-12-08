//
//  ReportsViewFile.swift
//  CS50
//
//  Created by Olivia Jimenez on 12/4/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    
    // Location manager to read device location
    @StateObject private var locationManager = LocationManager()
    var body: some View {
        TabView {
            // MAP TAB
            MapKitContentView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            // RESOURCES TAB
            NavigationStack {
                ResourcesView_Real()
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
