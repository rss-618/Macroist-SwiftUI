//
//  RootView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import SwiftUI
import ComposableArchitecture

public struct RootView: View {
    
    @State var store: StoreOf<Root>
    
    public var body: some View {
        WithPerceptionTracking {
            switch store.currentTab {
            case .login:
                LoginView(store: store.scope(state: \.loginState, action: \.login))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .home:
                HomeView(store: store.scope(state: \.homeState, action: \.home))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    
    public init(store: StoreOf<Root>) {
        self.store = store
    }
}
