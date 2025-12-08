//
//  ReportsViewFile.swift
//  CS50
//
//  Created by Olivia Jimenez on 12/4/25.
//

import Foundation
import FirebaseFirestore
import Combine

// View model that gives a live-updating list of reports to SwiftUI views
class LegacyReportsViewModel: ObservableObject {
    @Published var reports: [Report] = []
    private var listener: ListenerRegistration?

    init() {
        startListening()
    }

    // Subscribe to Firestore for active (last 4 hours) reports
    func startListening() {
        listener = ReportService.shared.listenToActiveReports(
            onChange: { [weak self] reports in
                DispatchQueue.main.async {
                    self?.reports = reports
                }
            },
            onError: { error in
                print("Listener error: \(error)")
            }
        )
    }

    // When the view model is deallocated, stop listening to Firestore to prevent memory leaks
    deinit {
        listener?.remove()
    }
}
