//
//  CloudKitHomeView.swift
//  CS50
//
//  Created by Olivia Jimenez on 11/26/25.
//

// THIS IS A TEST

import SwiftUI

struct CloudKitHomeView: View {

    @State private var isSaving = false
    @State private var saveResultMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("ICE Activity Tracker - Backend Test")
                .font(.headline)

            Button {
                testCreateDummyReport()
            } label: {
                Text(isSaving ? "Saving..." : "Create Dummy Report")
            }
            .disabled(isSaving)

            if let message = saveResultMessage {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Spacer()
        }
        .padding()
    }

    private func testCreateDummyReport() {
        isSaving = true
        saveResultMessage = nil

        // Example coordinates: somewhere in the US (very rough)
        let testLat = 40.7128
        let testLng = -74.0060

        ReportService.shared.submitReport(
            lat: testLat,
            lng: testLng,
            description: "Test ICE report from ContentView",
            imageData: nil
        ) { result in
            DispatchQueue.main.async {
                self.isSaving = false
                switch result {
                case .success:
                    self.saveResultMessage = "Report saved! Check Firestore 'reports' collection."
                case .failure(let error):
                    self.saveResultMessage = "Failed to save report: \(error.localizedDescription)"
                }
            }
        }
    }
}
