//
//  ReportService.swift
//  CS50
//
//  Created by Olivia Jimenez on 11/29/25.
//

// TEST TEST HARDCODED REPORT NEEDS TO BE UPDATED

import Foundation
import FirebaseFirestore

final class ReportService {

    // Singleton instance
    static let shared = ReportService()

    // Firestore reference
    private let db: Firestore

    private init() {
        print("✅ ReportService init, configuring Firestore")
        self.db = Firestore.firestore()
    }

    // Convenience accessor for the "reports" collection
    private var reportsCollection: CollectionReference {
        db.collection("reports")
    }

    /// Submit a new report (Firestore only, no image upload yet)
    func submitReport(
        lat: Double,
        lng: Double,
        description: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        print("submitReport called (Firestore version)")

        let data: [String: Any] = [
            "lat": lat,
            "lng": lng,
            "description": description,
            "createdAt": Timestamp(date: Date())
        ]

        print("📝 About to call addDocument with data: \(data)")

        reportsCollection.addDocument(data: data) { error in
            print("📥 addDocument completion called")
            
            if let error = error {
                print("🔥 Firestore addDocument error: \(error)")
                completion(.failure(error))
            } else {
                print("✅ Firestore document added successfully")
                completion(.success(()))
            }
            
        }
   
    }
    func fetchActiveReportsOnce(completion: @escaping (Result<[Report], Error>) -> Void) {
        print("📡 fetchActiveReportsOnce called")

        let cutoff = Timestamp(date: Date().addingTimeInterval(-4 * 60 * 60))

        reportsCollection
            .whereField("createdAt", isGreaterThan: cutoff)
            .getDocuments { snapshot, error in

                if let error = error {
                    print("🔥 fetch error: \(error)")
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

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

                print("📥 fetched \(reports.count) reports")
                completion(.success(reports))
            }
    }
    func listenToActiveReports(
        onChange: @escaping ([Report]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration {

        print(" Setting up Firestore listener")

        let cutoff = Timestamp(date: Date().addingTimeInterval(-4 * 60 * 60))

        return reportsCollection
            .whereField("createdAt", isGreaterThan: cutoff)
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    print("listener error: \(error)")
                    onError(error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    onChange([])
                    return
                }

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
