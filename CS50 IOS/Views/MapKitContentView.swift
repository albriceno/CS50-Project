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
    
    func addPin(at coordinate: CLLocationCoordinate2D)
    {
        let newPin = MapPin(
            coordinate: coordinate,
            title: "ICE Spotted",
            subtitle: "Detailed Report Below:"
        )
        pins.append(newPin)
    }
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
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
                            
                        }
                        .onTapGesture {
                            selectedPin = pin
                        }
                    }
                }
                
            }
            
            .gesture(
                TapGesture()
                    .onEnded { _ in }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded{ gesture in
                              let tapPoint = gesture.location
                              if let coordinate = proxy.convert(tapPoint, from: .local)
                              {
                                  viewModel.addPin(at: coordinate)
                              }
                    }
            
            )
            .sheet(item: $selectedPin) { pin in
                VStack (spacing: 12) {
                    Text(pin.title).font(.title)
                    Text(pin.subtitle)
                }
                .padding()
            }
        
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            
        }
        
        
    }

    

    func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}
