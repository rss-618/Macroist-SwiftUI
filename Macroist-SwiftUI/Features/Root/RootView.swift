//
//  RootView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import SwiftUI
import ComposableArchitecture

public struct RootView: View {
    
    @Perception.Bindable var store: StoreOf<Root>
    
    public var body: some View {
        WithPerceptionTracking {
            switch store.currentTab {
            case .login:
                LoginView(store: store.scope(state: \.loginState, action: \.login))
                    .maxFrame()
            case .home:
                HomeView(store: store.scope(state: \.homeState, action: \.home))
                    .maxFrame()
            }
        }
    }
    
    
    public init(store: StoreOf<Root>) {
        self.store = store
    }
}
