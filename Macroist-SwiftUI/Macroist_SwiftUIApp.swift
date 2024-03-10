//
//  Macroist_SwiftUIApp.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import SwiftUI
import ComposableArchitecture
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct Macroist_SwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: .init(), reducer: {
                Root()
            }))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// -- Firebase Init --
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
