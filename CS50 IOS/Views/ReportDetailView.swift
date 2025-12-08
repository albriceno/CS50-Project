//
//  ReportDetailView.swift
//  CS50
//
//  Created by Olivia Jimenez on 12/6/25.
//

import SwiftUI
import MapKit

struct ReportDetailView: View {
    let report: Report
    
    private let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    // A small region centered on the report location
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: report.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    var body: some View {
        ZStack {
            Color("AppBackground").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Header card (title bubble)
                    ReportDetailHeader()
                        .padding(.top, 8)
                
                    
                    // Details card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Possible ICE Activity Reported")
                                .font(.headline)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .foregroundColor(.secondary)
                            Text(formatter.string(from: report.createdAt))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        Text("Description")
                            .font(.headline)
                        Text(report.description.isEmpty ? "No description provided." : report.description)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 2, y: 1)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 16)
                }
                // Map preview card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Location")
                        .font(.headline)
                    
                    Map(initialPosition: .region(region)) {
                        // Simple annotation marker
                        Annotation("Reported", coordinate: report.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
                        }
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 2, y: 1)
                .padding(.horizontal)
                .padding(.top, 4)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
