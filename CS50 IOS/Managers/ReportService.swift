//
//  ReportService.swift
//  CS50
//
//  Created by Olivia Jimenez on 11/29/25.
//
// 11/29 - TODO; change image url to direct upload

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class ReportService {

    static let shared = ReportService()

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    private init() {}

    private var reportsCollection: CollectionReference {
        db.collection("reports")
    }

    // MARK: - Public API
    //Optional image data
    func submitReport(
        lat: Double,
        lng: Double,
        description: String,
        imageData: Data?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // 1. Create a new document reference (so we know the ID for image path)
        let docRef = reportsCollection.document()
        let reportId = docRef.documentID

        // 2. Helper closure to actually write Firestore doc
        func writeReportDocument(imageURL: String?) {
            var data: [String: Any] = [
                "lat": lat,
                "lng": lng,
                "description": description,
                "createdAt": FieldValue.serverTimestamp()
            ]

            if let imageURL = imageURL {
                data["imageURL"] = imageURL
            }

            docRef.setData(data) { error in
                if let error = error {
                    print("Error writing report document: \(error)")
                    completion(.failure(error))
                } else {
                    print("Report saved with ID \(reportId)")
                    completion(.success(()))
                }
            }
        }

        // 3. If no image, just write doc and return
        guard let imageData = imageData else {
            writeReportDocument(imageURL: nil)
            return
        }

        // 4. If there IS an image, upload to Storage first
        let storageRef = storage.reference().child("reportImages/\(reportId).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("🔥 Error uploading image: \(error)")
                completion(.failure(error))
                return
            }

            // Get download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("🔥 Error getting download URL: \(error)")
                    completion(.failure(error))
                    return
                }

                let imageURL = url?.absoluteString
                writeReportDocument(imageURL: imageURL)
            }
        }
    }

    /// One-time fetch of all active reports (≤ 4 hours old)
    func fetchActiveReportsOnce(completion: @escaping (Result<[Report], Error>) -> Void) {
        let cutoff = fourHoursAgoTimestamp()

        reportsCollection
            .whereField("createdAt", isGreaterThan: cutoff)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("🔥 Error fetching reports: \(error)")
                    completion(.failure(error))
                    return
                }

                guard let snapshot = snapshot else {
                    completion(.success([]))
                    return
                }

                let reports = snapshot.documents.compactMap { self.reportFromDocument($0) }
                completion(.success(reports))
            }
    }
    // Live listener for active reports.
    func listenToActiveReports(
        onChange: @escaping ([Report]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration {
        let cutoff = fourHoursAgoTimestamp()

        return reportsCollection
            .whereField("createdAt", isGreaterThan: cutoff)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("🔥 Snapshot listener error: \(error)")
                    onError(error)
                    return
                }

                guard let snapshot = snapshot else {
                    onChange([])
                    return
                }

                let reports = snapshot.documents.compactMap { self.reportFromDocument($0) }
                let filtered = reports.filter { $0.createdAt >= Date().addingTimeInterval(-4 * 60 * 60) }
                onChange(filtered)
            }
    }

    // MARK: - Helpers

    private func fourHoursAgoTimestamp() -> Timestamp {
        let cutoffDate = Date().addingTimeInterval(-4 * 60 * 60)
        return Timestamp(date: cutoffDate)
    }

    private func reportFromDocument(_ doc: DocumentSnapshot) -> Report? {
        guard
            let data = doc.data(),
            let lat = data["lat"] as? Double,
            let lng = data["lng"] as? Double,
            let description = data["description"] as? String,
            let createdAt = data["createdAt"] as? Timestamp
        else {
            print("⚠️ Missing required fields in document \(doc.documentID)")
            return nil
        }

        // imageURL is non-optional in Report model; provide a default if absent.
        let imageURL = data["imageURL"] as? String ?? ""

        return Report(
            id: doc.documentID,
            lat: lat,
            lng: lng,
            description: description,
            imageURL: imageURL,
            createdAt: createdAt.dateValue()
        )
    }
}
