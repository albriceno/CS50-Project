//
//  MapKitContentView.swift
//  CS50
//
//  Created by Olivia Jimenez on 11/26/25.
//

import Firebase
import FirebaseFirestore
import SwiftUI
import SwiftData
import MapKit
import CoreLocation
import Combine

struct MapPin: Identifiable{
    let id = UUID()
    var title: String
    var subtitle: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

class MapViewModel: ObservableObject {
    @Published var pins: [MapPin] = []
    
    func addPin(at coordinate: CLLocationCoordinate2D) -> MapPin
    {
        let newPin = MapPin(
            title: "ICE Spotted",
            subtitle: "",
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        pins.append(newPin)
        
        savePinToFirestore(newPin)
        
        return newPin
    }
    
    func savePinToFirestore(_ pin: MapPin){
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "id": pin.id.uuidString,
            "title": pin.title,
            "subtitle": pin.subtitle,
            "latitude": pin.latitude,
            "longitude": pin.longitude
        ]
        
        db.collection("pins").document(pin.id.uuidString).setData(data) { error in
            if let error = error {
                print("Error saving pin: \(error.localizedDescription)")
            }
            else {
                print("Pin saved successfully.")
            }
        }
    }
    
    func updatePin(_ updatedPin: MapPin) {
        if let index = pins.firstIndex(where: { $0.id == updatedPin.id }) {
            pins[index] = updatedPin
        }
        
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
                                let newPin = viewModel.addPin(at: coordinate)
                                selectedPin = newPin
                            }
                        }
                    
                )
                .sheet(item: $selectedPin) { pin in
                    PinEditorView(pin: pin) {
                        updatedPin in
                        viewModel.updatePin(updatedPin)
                    }
                }
                
                
                
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                
            }
            
            
        }
        
            
        }
