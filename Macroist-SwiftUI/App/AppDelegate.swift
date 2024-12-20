//
//  AppDelegate.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 12/10/24.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // https://firebase.google.com/docs/firestore/quickstart?authuser=0&hl=en&_gl=1*1ag7s2q*_ga*MTgzMTI3NzQ4Mi4xNzA5OTM2OTcy*_ga_CW55HF8NVT*MTcxMDM4Mzg0MC43LjEuMTcxMDM4NDQzMi4yOC4wLjA.#swift
        FirebaseApp.configure()
        Firestore.firestore() // Creates instance of firestore db access
        return true
    }
}
