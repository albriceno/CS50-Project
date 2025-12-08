//
//  ReportService.swift
//  CS50
//
//  Created by Olivia Jimenez on 11/29/25.
//

import Foundation
import FirebaseFirestore

// service responsible for all Firestore report I/O
final class ReportService {

    // Shared global instance used throughout the app
    static let shared = ReportService()

    // Reference to Firestore database
    private let db: Firestore

    // Private initializer so the service can only be created once
    private init() {
        // Grab the default Firestore instance configured in Firebase
        self.db = Firestore.firestore()
    }
    
    private var reportsCollection: CollectionReference {
        db.collection("reports")
    }

    // Write a new ice report document to Firestore.
    func submitReport(
        lat: Double,
        lng: Double,
        description: String,
        createdAt: Date,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        print("submitReport called (Firestore version)")

        // data payload that will be stored in the Firestore document
        let data: [String: Any] = [
            "lat": lat,
            "lng": lng,
            "description": description,
            // saving timestamp so that can be used for expiration logic later
            "createdAt": Timestamp(date: createdAt)
        ]

        // Add a new document with an auto-generated ID under "reports"
        reportsCollection.addDocument(data: data) { error in
            print("addDocument completion called")
            
            if let error = error {
                // Error-management
                print("Firestore addDocument error: \(error)")
                completion(.failure(error))
            } else {
                print("Firestore document added successfully")
                completion(.success(()))
            }
            
        }
    }
    
    // One time fetch of all active reports in last four hours.
    func fetchActiveReportsOnce(completion: @escaping (Result<[Report], Error>) -> Void) {
        print("fetchActiveReportsOnce called")

        let cutoff = Timestamp(date: Date().addingTimeInterval(-4 * 60 * 60))

        reportsCollection
            .whereField("createdAt", isGreaterThan: cutoff)
            .getDocuments { snapshot, error in

                if let error = error {
                    print("fetch error: \(error)")
                    completion(.failure(error))
                    return
                }

                // If there are no documents, just return an empty array
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                // Map each Firestore document into the local Report model
                let reports = documents.compactMap { doc -> Report? in
                    let data = doc.data()
                    guard
                        let lat = data["lat"] as? Double,
                        let lng = data["lng"] as? Double,
                        let description = data["description"] as? String,
                        let createdAt = data["createdAt"] as? Timestamp
                    else { return nil }

                    return Report(
                        id: doc.documentID,
                        lat: lat,
                        lng: lng,
                        description: description,
                        createdAt: createdAt.dateValue()
                    )
                }

                print("fetched \(reports.count) reports")
                completion(.success(reports))
            }
    }
    
    // Attach a realtime listener for active reports
    func listenToActiveReports(
        onChange: @escaping ([Report]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration {

        // Same 4-hour cutoff as the one-time fetch
        let cutoff = Timestamp(date: Date().addingTimeInterval(-4 * 60 * 60))

        // Create a query that only returns recent reports and listen for live updates
        return reportsCollection
            .whereField("createdAt", isGreaterThan: cutoff)
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    print("listener error: \(error)")
                    onError(error)
                    return
                }

                // If the query currently has no matching docs, emit an empty list
                guard let documents = snapshot?.documents else {
                    onChange([])
                    return
                }
                
                // Map documents into Report models every time the snapshot updates
                let reports = documents.compactMap { doc -> Report? in
                    let data = doc.data()
                    guard
                        let lat = data["lat"] as? Double,
                        let lng = data["lng"] as? Double,
                        let description = data["description"] as? String,
                        let createdAt = data["createdAt"] as? Timestamp
                    else { return nil }

                    return Report(
                        id: doc.documentID,
                        lat: lat,
                        lng: lng,
                        description: description,
                        createdAt: createdAt.dateValue()
                    )
                }
                onChange(reports)
            }
    }
}
