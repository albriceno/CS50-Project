//
//  CS50_IOSApp.swift
//  CS50 IOS
//
//  Created by Olivia Jimenez on 11/25/25.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth

@main
struct CS50_IOSApp: App {

    init() {
        FirebaseApp.configure()
        signInAnonymouslyIfNeeded()
    }
    private func signInAnonymouslyIfNeeded() {
        // Sign in if not already authenticated
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { result, error in
                if let error = error {
                    print("Firebase anonymous auth failed: \(error.localizedDescription)")
                } else {
                    print("Signed in anonymously with UID: \(result?.user.uid ?? "no-uid")")
                }
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
