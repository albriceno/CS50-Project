//
//  ContentView.swift
//  CS50 IOS
//
//  Created by Olivia Jimenez on 11/25/25.
//
import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct ContentView: View {
    var body: some View {
        TabView {
            MapKitContentView()
                .tabItem {
                    Label("Main", systemImage: "list.bullet")
                }
            

            CloudKitHomeView()
                .tabItem {
                    Label("CloudKit", systemImage: "cloud")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
