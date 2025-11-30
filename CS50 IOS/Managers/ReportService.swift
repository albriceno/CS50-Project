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
        imageData: Data?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        print("📨 submitReport called (Firestore version)")

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
}
