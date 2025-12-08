//
//  ReportsTabView.swift
//  CS50
//
//  Created by Olivia Jimenez on 12/6/25.
//

import SwiftUI

struct ReportDetailHeader: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Centered bubble title
            Text("Report Details")
                .font(.headline)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2, y: 1)
                )
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Back button on top-left, not affecting centering
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(Color(.systemBackground))
                                .shadow(radius: 2, y: 1)
                        )
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 6)
        .padding(.top, 4)
        .background(
            Color("AppBackground")
                .ignoresSafeArea(edges: .top)
        )
    }
}


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
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Icon + title + time
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.red)
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Possible ICE Activity Reported")
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                            
                            Text(formatter.string(from: report.createdAt))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Description")
                            .font(.subheadline.bold())
                        
                        Text(report.description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 2, y: 1)
                .padding(.horizontal)
                
                Spacer(minLength: 8)
            }
            .padding(.top, 12)
        }
        .background(Color("AppBackground").ignoresSafeArea())
        //
        .safeAreaInset(edge: .top) {
            ReportDetailHeader()
        }
        // hide system nav bar so only see custom header
        .toolbar(.hidden, for: .navigationBar)
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
