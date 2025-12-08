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
        // Configure Firebase SDK
        FirebaseApp.configure()
        signInAnonymouslyIfNeeded()
    }
    // Helper that signs the user in anonymously the first time they use the app
    private func signInAnonymouslyIfNeeded() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { result, error in
                // for debgging
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
                // global color
                .tint(Color("AppAccent"))
        }
    }
}
