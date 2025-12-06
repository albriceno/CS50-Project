//
//  ReportsTabView.swift
//  CS50
//
//  Created by Olivia Jimenez on 12/6/25.
//

import SwiftUI

struct ReportsTabView: View {
    @StateObject private var viewModel = LegacyReportsViewModel()
    
    private let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    var body: some View {
        NavigationStack {
            List(viewModel.reports) { report in
                VStack(alignment: .leading, spacing: 4) {
                    Text(report.description)
                        .font(.headline)
                    
                    Text("Lat: \(report.lat), Lng: \(report.lng)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Created: \(formatter.string(from: report.createdAt))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Reports")
        }
    }
}
