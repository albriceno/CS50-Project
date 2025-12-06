//
//  ReportsViewFile.swift
//  CS50
//
//  Created by Olivia Jimenez on 12/4/25.
//

import Foundation
import FirebaseFirestore
import Combine

class LegacyReportsViewModel: ObservableObject {
    @Published var reports: [Report] = []
    private var listener: ListenerRegistration?

    init() {
        startListening()
    }

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

    deinit {
        listener?.remove()
    }
}
