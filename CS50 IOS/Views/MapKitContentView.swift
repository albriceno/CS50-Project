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

//creating pin struct
struct MapPin: Identifiable {
    
    //Declaring variables for MapPin that are displayed when pin is made or clicked
    var id: UUID
    var title: String
    var subtitle: String
    var latitude: Double
    var longitude: Double
    var createdAt: Date
    
    //coverting latitude and longitude variables above into MapKit coordinate to be used throughout the file
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    //Initializing MapPin object
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

//made into observable object in order to update ui automatically
class MapViewModel: ObservableObject {
    
    //creating pins array to store objects of struct MapPin
    @Published var pins: [MapPin] = []
    
    //Function for creating new pin
    func addPin(at coordinate: CLLocationCoordinate2D) -> MapPin {
        //adding pin to array
        let newPin = MapPin(
            title: "ICE Spotted",
            subtitle: "",
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            createdAt: Date()
        )
        
        //making new pin a value that can be managed by SwiftUI
        pins.append(newPin)
        
        //calling function to save pin to Firebase
        savePinToFirestore(newPin)
        
        
        return newPin
    }
    
    
    //for changing pin information and saving
    func updatePin(_ updatedPin: MapPin) {
        
        //Accessing pin id in order to update it
        if let index = pins.firstIndex(where: { $0.id == updatedPin.id }) {
            pins[index] = updatedPin
        }
        
        //saving newly updated pin to Firebase
        savePinToFirestore(updatedPin)
    }
    
    //Saving pin to Firebase
    func savePinToFirestore(_ pin: MapPin) {
        let db = Firestore.firestore()
        //Putting pin into dict format for Firebase
        // fields saved to 'pin' collection
        let data: [String: Any] = [
            "id": pin.id.uuidString,
            "title": pin.title,
            "subtitle": pin.subtitle,
            "latitude": pin.latitude,
            "longitude": pin.longitude,
            // timestamp for later cutoff
            "createdAt": Timestamp(date: pin.createdAt)
        ]
        
        //uuid is used to keep track of pins
        db.collection("pins").document(pin.id.uuidString).setData(data) { error in
            
            //giving error message if not saved
            if let error = error {
                // debgugging
                print("Error saving pin: \(error.localizedDescription)")
            } else {
                print("Pin saved successfully.")
            }
        }
    }
    
    func loadPinsFromFirestore() {
        let db = Firestore.firestore()
        
        db.collection("pins").getDocuments { snapshot, error in
            
            //handling error messafes if loading pins doesn't work
            // 4 hours ago cut off
            let cutoffDate = Date().addingTimeInterval(-4 * 60 * 60)
            let cutoff = Timestamp(date: cutoffDate)
            
            
            db.collection("pins")
            // filters recent pins only
                .whereField("createdAt", isGreaterThan: cutoff)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error loading pins: \(error.localizedDescription)")
                        return
                    }
                    
                    //returning pin information when app is opened
                    guard let documents = snapshot?.documents else {
                        print("No pins found in Firestore.")
                        return
                    }
                    
                    //changing pins to stored to tangible pins on map
                    // Convert each Firestore document back into a MapPin model
                    let fetchedPins: [MapPin] = documents.compactMap { doc in
                        let data = doc.data()
                        guard
                            
                            //validating values
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
                        
                        //if valid, pin is returned
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

    
  
}
struct MapKitContentView: View {
    
    //calling function for user location
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = MapViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    //Property wrapped for camera to be modified as user explores map and changes the framing of the map, intialized here
    @State private var camera = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 42.3744, longitude: -71.1182),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    @State private var selectedPin: MapPin?
    @State private var showingEditor = false
    
    //center of map, intialized to Harvard, but does update when user clicks center on location
    @State private var currentCenter = CLLocationCoordinate2D(latitude: 42.3744, longitude: -71.1182)
    
    //zoom distance
    @State private var currentDistance: CLLocationDistance = 1000
    
    var body: some View {
        
        ZStack(alignment: .top) {
            //container view
            MapReader { proxy in
                ZStack {
                    Color("AppBackground").ignoresSafeArea()
                    
                    Map(position: $camera)
                    {
                        //for loop displaying each pin
                        ForEach(viewModel.pins) { pin in
                            Annotation(pin.title, coordinate: pin.coordinate) {
                                VStack(spacing: 4) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title)
                                        .foregroundStyle(.red)
                                }
                                
                                //insuring that when pin is created, it takes up an area
                                .contentShape(Rectangle())
                                .padding(10)
                                
                                //selecting pin when tapped
                                .onTapGesture {
                                    selectedPin = pin
                                }
                            }
                        }
                    }
                    
                    //tracks camera movement and changes center and zoom distance accordingly
                    .onMapCameraChange { context in
                        currentCenter = context.region.center
                        currentDistance = context.camera.distance
                    }
                    
                    //updates user's location
                    .onReceive(locationManager.$region){
                        newRegion in
                        camera = .camera(MapCamera(
                            centerCoordinate: newRegion.center,
                            distance: currentDistance
                        ))
                    }
                    
                    //when user clicks on map twice, calls maptap function to add pin
                    .highPriorityGesture(
                        SpatialTapGesture(count: 2)
                            .onEnded {value in
                                let loc = value.location
                                handleMapTap(proxy: proxy, tapLocation: loc)
                            }
                    )
                    .mapControls {
                        
                        //center on user's location button
                        MapUserLocationButton()
                        MapCompass()
                    }
                    
                    //sheet for filling out information about pin, mainly description of report
                    .sheet(item: $selectedPin) { pin in
                        PinEditorView(pin: pin) { updatedPin in
                            
                            // Updates pin locally and saves to pins collection
                            viewModel.updatePin(updatedPin)
                            
                            // Creates report in the reports collection
                            // Update pin locally and saves to pins collection
                            viewModel.updatePin(updatedPin)
                            
                            // Also create a Report in the "reports" collection
                            let description = updatedPin.subtitle
                            let createdAt = Date()
                            ReportService.shared.submitReport(
                                lat: updatedPin.latitude,
                                lng: updatedPin.longitude,
                                description: description,
                                createdAt: createdAt
                            ) { result in
                                switch result {
                                    
                                    //handles error messages
                                case .success:
                                    print("Report created from pin.")
                                case .failure(let error):
                                    print("Failed to create report from pin: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                    //uses layout containers to display buttons on right side of screen, right under center user location button
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(spacing: 5) {
                                Button{
                                    //zooming in, changing zoom distance
                                    currentDistance *= 0.8
                                    camera = .camera(
                                        MapCamera(
                                            //updating camera, or view of map region
                                            centerCoordinate: currentCenter,
                                            distance: currentDistance
                                        )
                                    )
                                } label : {
                                    //given plus sign label to zoom in button
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.blue)
                                }
                                
                                
                                Button{
                                    
                                    //zooming out
                                    currentDistance *= 1.2
                                    camera = .camera(
                                        MapCamera(
                                            centerCoordinate: currentCenter,
                                            distance: currentDistance
                                        )
                                    )
                                } label: {
                                    
                                    //giving minus sign label to zoom out button
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            //placing zoom buttons on side of screen, changing space between buttons and bottom of screen
                            .padding(.trailing, 16)
                            .padding(.bottom, 175)
                            
                            
                        }
                        
                        
                    }
                }
                
                //loads pins when app opens
                .onAppear {
                    viewModel.loadPinsFromFirestore()
                }
            }
            //Header Text Box with instruction for user
            Text("Double Tap to Create Report")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.5))
                .padding(.top, 0)
                .padding(.vertical, 4)
                .ignoresSafeArea(edges: .top)
        }
    }
    
    //function that gives meaning to double tap gesture
    private func handleMapTap(proxy: MapProxy, tapLocation: CGPoint) {
        guard let coordinate = proxy.convert(tapLocation, from: .local) else {return}
        
        //not allowing user to create a pin where a pin is already located, or assures that tap is on map and not on pin
        let TappedExistingPin = viewModel.pins.contains {
            pin in
            guard let pinPoint: CGPoint = proxy.convert(pin.coordinate, to: .local) else { return false }
            let distance = hypot(pinPoint.x - tapLocation.x, pinPoint.y - tapLocation.y)
            return distance < 30
        }
        
        if TappedExistingPin { return }
        
        let newPin = viewModel.addPin(at: coordinate)
        
        //pulls up sheet for user to edit description when pin is made
        DispatchQueue.main.async {
            selectedPin = newPin
        }
        
    }
    
}
