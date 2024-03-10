//
//  SwiftUIView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import SwiftUI
import ComposableArchitecture

public struct RootView: View {
    
    let store: StoreOf<Root>
    
    public var body: some View {
        WithViewStore(store, observe: \.currentTab) { viewStore in
            switch viewStore.state {
            case .login:
                LoginView(store: store.scope(state: \.loginState, action: \.login))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .home:
                MainCoordinatorView(store: store.scope(state: \.mainCoordinatorState, action: \.mainCoordinator))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .tapToDismissKeyboard()
    }
    
    public init(store: StoreOf<Root>) {
        self.store = store
    }
}
