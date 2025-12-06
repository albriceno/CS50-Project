//
//  PinEditorView.swift
//  CS50 IOS
//
//  Created by Alejandra Briceno on 12/5/25.
//

import Foundation
import SwiftUI
import CoreLocation


struct PinEditorView: View {
    
    @Environment(\.dismiss) private var dismiss
        
        @State var pin: MapPin
        var onSave: (MapPin) -> Void
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Title")) {
                        TextField("Title", text: $pin.title)
                    }
                    
                    Section(header: Text("Subtitle / Notes")) {
                        TextField("Subtitle", text: $pin.subtitle)
                    }
                    
                    Section(header: Text("Coordinates")) {
                        Text("Lat: \(pin.coordinate.latitude)")
                        Text("Lon: \(pin.coordinate.longitude)")
                    }
                }
                .navigationTitle("Edit Pin")
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
