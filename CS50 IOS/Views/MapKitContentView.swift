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
import Combine

struct MapPin: Identifiable{
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
}

class MapViewModel: ObservableObject {
    @Published var pins: [MapPin] = []
}

struct MapKitContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject private var viewModel = MapViewModel()
    @State private var camera = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.3744, longitude: -71.1182),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    
    @State private var selectedPin: MapPin?
    @State private var showingEditor = false
    
    var body: some View {
        MapReader { proxy in
            Map(position: $camera) {
                
                ForEach(viewModel.pins) { pin in
                    Annotation(pin.title, coordinate: pin.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
                                .onTapGesture {
                                    selectedPin = pin
                                    showingEditor = true
                                }
                        }
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            
        }
        
        .sheet(item:$selectedPin) { pin in
            PinEditorView(pin: pin) { updatedPin in
                if let index = viewModel.pins.firstIndex(where: { $0.id == pin.id }) {
                    viewModel.pins[index] = updatedPin
                    
                }
            }
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
