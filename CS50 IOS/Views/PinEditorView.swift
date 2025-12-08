//
//  PinEditorView.swift
//  CS50 IOS
//
//  Created by Alejandra Briceno on 12/5/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct PinEditorView: View {
    
    @Environment(\.dismiss) private var dismiss
        
    @State var pin: MapPin
    var onSave: (MapPin) -> Void
        
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Headline")) {
                    Text("Possible ICE Activity Reported")
                        .font(.headline)
                }
                // Description, notes the user can edit
                Section(header: Text("Description")) {
                    TextField("Describe what you saw...", text: $pin.subtitle, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section(header: Text("Coordinates")) {
                    Text("Lat: \(pin.coordinate.latitude)")
                    Text("Lon: \(pin.coordinate.longitude)")
                }
            }
            .navigationTitle("Report Details")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(pin)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
