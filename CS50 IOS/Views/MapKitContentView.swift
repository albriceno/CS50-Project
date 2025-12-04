//
//  MapKitContentView.swift
//  CS50
//
//  Created by Olivia Jimenez on 11/26/25.
//


import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct MapKitContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
   
    @State private var camera = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))

    var body: some View {
        NavigationSplitView {
            List {
                
            }
            
        }

        Map(position: $camera)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}
