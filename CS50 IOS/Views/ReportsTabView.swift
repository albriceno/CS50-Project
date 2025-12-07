//
//  ReportsTabView.swift
//  CS50
//
//  Created by Olivia Jimenez on 12/6/25.
//

import SwiftUI

struct ReportDetailView: View {
    let report: Report
    
    private let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Headline
                Text("Possible ICE Activity Reported")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Date/time
                Text("Reported at \(formatter.string(from: report.createdAt))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                // Full description
                Text(report.description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
        .navigationTitle("Report Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

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
                NavigationLink {
                    ReportDetailView(report: report)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Possible ICE Activity Reported")
                            .font(.headline)
                        Text(formatter.string(from: report.createdAt))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
            // This makes the list background the app color instead of system white
            .scrollContentBackground(.hidden)
            .background(Color("AppBackground").ignoresSafeArea())
            
            //  makes  header small and at the top
            .navigationTitle("Reports")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
