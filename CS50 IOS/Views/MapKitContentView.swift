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
    var createdAt: Date
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        latitude: Double,
        longitude: Double,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
    }
}

class MapViewModel: ObservableObject {
    @Published var pins: [MapPin] = []
    
    func addPin(at coordinate: CLLocationCoordinate2D) -> MapPin {
        let newPin = MapPin(
            title: "ICE Spotted",
            subtitle: "",
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            createdAt: Date()
        )
        pins.append(newPin)
        savePinToFirestore(newPin)
        return newPin
    }
    
    func updatePin(_ updatedPin: MapPin) {
        if let index = pins.firstIndex(where: { $0.id == updatedPin.id }) {
            pins[index] = updatedPin
        }
        savePinToFirestore(updatedPin)
    }
    
    func savePinToFirestore(_ pin: MapPin) {
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "id": pin.id.uuidString,
            "title": pin.title,
            "subtitle": pin.subtitle,
            "latitude": pin.latitude,
            "longitude": pin.longitude,
            "createdAt": Timestamp(date: pin.createdAt)
        ]
        
        db.collection("pins").document(pin.id.uuidString).setData(data) { error in
            if let error = error {
                print("Error saving pin: \(error.localizedDescription)")
            } else {
                print("Pin saved successfully.")
            }
        }
    }
    
    func loadPinsFromFirestore() {
        let db = Firestore.firestore()
        
        // 4 hours ago
        let cutoffDate = Date().addingTimeInterval(-4 * 60 * 60)
        let cutoff = Timestamp(date: cutoffDate)

        
        db.collection("pins")
            .whereField("createdAt", isGreaterThan: cutoff)
            .getDocuments { snapshot, error in
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
                    let longitude = data["longitude"] as? Double,
                    let createdAtTimestamp = data["createdAt"] as? Timestamp
                else {
                    print("Skipping pin \(doc.documentID) – invalid or missing fields")
                    return nil
                }
                
                return MapPin(
                    id: uuid,
                    title: title,
                    subtitle: subtitle,
                    latitude: latitude,
                    longitude: longitude,
                    createdAt: createdAtTimestamp.dateValue()
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
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = MapViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var camera = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 42.3744, longitude: -71.1182),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    @State private var selectedPin: MapPin?
    @State private var showingEditor = false
    @State private var currentCenter = CLLocationCoordinate2D(latitude: 42.3744, longitude: -71.1182)
    @State private var currentDistance: CLLocationDistance = 1000
    
    var body: some View {
        MapReader { proxy in
            ZStack {
                Color("AppBackground").ignoresSafeArea()
                
                Map(position: $camera)
                {
                    ForEach(viewModel.pins) { pin in
                        Annotation(pin.title, coordinate: pin.coordinate) {
                            VStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.red)
                            }
                            .contentShape(Rectangle())
                            .padding(10)
                            .onTapGesture {
                                selectedPin = pin
                            }
                        }
                    }
                }
                
                .onMapCameraChange { context in
                    currentCenter = context.region.center
                    currentDistance = context.camera.distance
                }
                .onReceive(locationManager.$region){
                    newRegion in
                    camera = .camera(MapCamera(
                        centerCoordinate: newRegion.center,
                        distance: currentDistance
                    ))
                }
                .highPriorityGesture(
                    SpatialTapGesture(count: 2)
                        .onEnded {value in
                            let loc = value.location
                            handleMapTap(proxy: proxy, tapLocation: loc)
                        }
                )
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                
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
                                print("Report created from pin.")
                            case .failure(let error):
                                print("Failed to create report from pin: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            VStack {
            Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 5) {
                            Button{
                                currentDistance *= 0.8
                                camera = .camera(
                                    MapCamera(
                                        centerCoordinate: currentCenter,
                                        distance: currentDistance
                                    )
                                )
                            } label : {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                            }
                            
                            
                            Button{
                                currentDistance *= 1.2
                                camera = .camera(
                                    MapCamera(
                                        centerCoordinate: currentCenter,
                                        distance: currentDistance
                                    )
                                )
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 175)
                        
                        
                    }
                                    
                    
                    }
            }
            .onAppear {
                viewModel.loadPinsFromFirestore()
            }
        }
    }
    private func handleMapTap(proxy: MapProxy, tapLocation: CGPoint) {
        guard let coordinate = proxy.convert(tapLocation, from: .local) else {return}
        let TappedExistingPin = viewModel.pins.contains {
            pin in
            guard let pinPoint: CGPoint = proxy.convert(pin.coordinate, to: .local) else { return false }
            let distance = hypot(pinPoint.x - tapLocation.x, pinPoint.y - tapLocation.y)
            return distance < 30
        }
        
        if TappedExistingPin { return }
        
        let newPin = viewModel.addPin(at: coordinate)
        
        DispatchQueue.main.async {
            selectedPin = newPin
        }
        
    }
   
    }
