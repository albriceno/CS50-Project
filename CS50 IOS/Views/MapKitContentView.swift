//
//  MapKitContentView.swift
//  CS50
//
//  Created by Olivia Jimenez on 11/26/25.
//

import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI
import SwiftData
import MapKit
import CoreLocation
import Combine

struct MapPin: Identifiable {
    var id: UUID
    var title: String
    var subtitle: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
    }
}

class MapViewModel: ObservableObject {
    @Published var pins: [MapPin] = []
    
    func addPin(at coordinate: CLLocationCoordinate2D) -> MapPin {
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
    
    func savePinToFirestore(_ pin: MapPin) {
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
            } else {
                print("Pin saved successfully.")
            }
        }
    }
    
    func updatePin(_ updatedPin: MapPin) {
        if let index = pins.firstIndex(where: { $0.id == updatedPin.id }) {
            pins[index] = updatedPin
        }
        savePinToFirestore(updatedPin)
    }
    
    func loadPinsFromFirestore() {
        let db = Firestore.firestore()
        
        db.collection("pins").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading pins: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No pins found in Firestore.")
                return
            }
            
            let fetchedPins: [MapPin] = documents.compactMap { doc in
                let data = doc.data()
                
                guard
                    let idString = data["id"] as? String,
                    let uuid = UUID(uuidString: idString),
                    let title = data["title"] as? String,
                    let subtitle = data["subtitle"] as? String,
                    let latitude = data["latitude"] as? Double,
                    let longitude = data["longitude"] as? Double
                else {
                    print("Skipping pin \(doc.documentID) – invalid or missing fields")
                    return nil
                }
                
                return MapPin(
                    id: uuid,
                    title: title,
                    subtitle: subtitle,
                    latitude: latitude,
                    longitude: longitude
                )
            }
            
            DispatchQueue.main.async {
                self.pins = fetchedPins
                print("Loaded \(fetchedPins.count) pins from Firestore.")
            }
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
            ZStack {
                Map(position: $camera) {
                    ForEach(viewModel.pins) { pin in
                        Annotation(pin.title, coordinate: pin.coordinate) {
                            VStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.red)
                            }
                            .contentShape(Rectangle())
                            .padding(30)
                            .highPriorityGesture(
                                TapGesture().onEnded {
                                selectedPin = pin
                            }
                                )
                        }
                    }
                    
                  
                }
                
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { location in
                            addPinAtTap()
                        }
                )
              
                .sheet(item: $selectedPin) { pin in
                    PinEditorView(pin: pin) { updatedPin in
                        // 1) Update pin locally + save to pins collection
                        viewModel.updatePin(updatedPin)
                        
                        // 2) Also create a Report in the "reports" collection
                        let description = updatedPin.subtitle
                        let createdAt = Date()
                        
                        ReportService.shared.submitReport(
                            lat: updatedPin.latitude,
                            lng: updatedPin.longitude,
                            description: description,
                            createdAt: createdAt
                        ) { result in
                            switch result {
                            case .success:
                                print("✅ Report created from pin.")
                            case .failure(let error):
                                print("🔥 Failed to create report from pin: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                
                VStack {
                    HStack {
                        let ogCoordinate = CLLocationCoordinate2D(latitude: 42.3744, longitude: -71.1182)
                        Button("Zoom In") {
                            camera = .camera(
                                MapCamera(
                                    centerCoordinate: camera.camera?.centerCoordinate ?? ogCoordinate,
                                    distance: (camera.camera?.distance ?? 1000) * 0.8
                                )
                            )
                        }
                        Button("Zoom Out") {

                            camera = .camera(
                                MapCamera(
                                    centerCoordinate: camera.camera?.centerCoordinate ?? ogCoordinate,
                                    distance: (camera.camera?.distance ?? 1000) * 1.2
                                )
                            )
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.loadPinsFromFirestore()
        }
        

        
    }
    
    private func addPinFromTap() {
        guard let 
    }
}
