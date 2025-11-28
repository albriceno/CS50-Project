//
//  CloudkitManager.swift
//  CS50
//
//  Created by Olivia Jimenez on 11/26/25.
//
import CloudKit

class CloudKitManager {
    static let shared = CloudKitManager()
    private let database = CKContainer.default().publicCloudDatabase

    // Save report (text only for now)
    func saveReport(_ text: String, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "Report")
        record["text"] = text as CKRecordValue

        database.save(record) { record, error in
            DispatchQueue.main.async {
                if let record = record {
                    completion(.success(record))
                } else {
                    completion(.failure(error!))
                }
            }
        }
    }

    // CLOUDKIT - Modern fetch API (iOS 15+)
    func fetchReports(completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        var results: [CKRecord] = []

        let query = CKQuery(recordType: "Report", predicate: NSPredicate(value: true))

        let operation = CKQueryOperation(query: query)

        operation.recordMatchedBlock = { _, result in
            switch result {
            case .success(let record):
                results.append(record)
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        operation.queryResultBlock = { finalResult in
            DispatchQueue.main.async {
                switch finalResult {
                case .success:
                    completion(.success(results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        database.add(operation)
    }
}
