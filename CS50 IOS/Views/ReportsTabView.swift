//
//  ReportsTabView.swift
//  CS50
//
//  Created by Olivia Jimenez on 12/6/25.
//

import SwiftUI

struct ReportDetailView: View {
    let report: Report
    
    // Local DateFormatter used to render the report timestamp
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

struct ReportRow: View {
    let report: Report
    let formatter: DateFormatter

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Alarm / ICE symbol
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 24))
                .foregroundColor(.red)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 6) {
                Text("Possible ICE Activity Reported")
                    .font(.headline)

                Text(formatter.string(from: report.createdAt))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("Tap for more details")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // pushes everything to the leading side, lets the card fill the row
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2, y: 1)
        .frame(maxWidth: .infinity, alignment: .leading) // stretch card to full label width
    }
}

struct ReportsHeader: View {
    var body: some View {
        VStack {
            Text("Reports")
                .font(.title3.bold())
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 3, y: 1)
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(Color("AppBackground").ignoresSafeArea())
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
    
    // Newest to oldest
    private var sortedReports: [Report] {
        viewModel.reports.sorted { $0.createdAt > $1.createdAt }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Screen background
                Color("AppBackground")
                    .ignoresSafeArea()
                
                if sortedReports.isEmpty {
                    VStack(spacing: 8) {
                        Text("No recent reports")
                            .font(.headline)
                        Text("New reports will appear here for 4 hours after they are created.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(sortedReports) { report in
                            NavigationLink {
                                ReportDetailView(report: report)
                            } label: {
                                ReportRow(report: report, formatter: formatter)
                            }
                            .padding(.vertical, 4)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            //  Sticky boxed header at the top
                    .safeAreaInset(edge: .top) {
                        ReportsHeader()
                            .background(Color("AppBackground").ignoresSafeArea(edges: .top))
                            .offset(y: -16)
                    }
                    // hide system nav bar title
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}
