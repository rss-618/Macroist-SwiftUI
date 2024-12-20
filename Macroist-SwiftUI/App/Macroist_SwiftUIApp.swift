//
//  Macroist_SwiftUIApp.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct Macroist_SwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WithPerceptionTracking {
            WindowGroup {
                RootView(store: Store(initialState: .init(), reducer: {
                    Root()
                }))
                .maxFrame()
            }
        }
    }
}
