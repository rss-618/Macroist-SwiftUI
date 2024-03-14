//
//  SettingsView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/11/24.
//

import ComposableArchitecture
import SwiftUI

public struct SettingsView: View {
    
    @State var store: StoreOf<Settings>
    
    @Dependency(\.apiClient) var apiClient
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                // Background View
                GenericBackgroundView()
                
                // Content
                VStack {
                    Text("Settings View")
                    Button {
                        do {
                            try apiClient.logout()
                        } catch {
                            print("No current user")
                        }
                        store.send(.logout)
                    } label: {
                        Text("Logout")
                    }
                }
            }
        }
    }
}
