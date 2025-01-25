//
//  SettingsView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/11/24.
//

import ComposableArchitecture
import SwiftUI

public struct SettingsView: View {
    
    @Perception.Bindable var store: StoreOf<Settings>
    
    @Dependency(\.apiClient) var apiClient
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                // Content
                VStack {
                    Text("Settings View")
                    Button {
                        Task { @MainActor in
                            do {
                                try await apiClient.logout()
                            } catch {
                                print("No current user?")
                            }
                            store.send(.logout)
                        }
                    } label: {
                        Text("Logout")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
