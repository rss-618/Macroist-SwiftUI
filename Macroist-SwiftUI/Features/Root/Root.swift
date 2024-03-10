//
//  Root.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct Root {
    
    @ObservableState
    public struct State: Equatable {
        public var currentTab: Tab = .login
        public var loginState: Login.State = .init()
        public var mainCoordinatorState: MainCoordinator.State = .init()
    }

    public enum Tab: Equatable {
        case login
        case home
    }
    
    public enum Action {
        case login(Login.Action)
        case mainCoordinator(MainCoordinator.Action)
        case logout
        case switchTab(Tab)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.loginState, action: /Action.login) {
            Login()
        }
        
        Scope(state: \.mainCoordinatorState, action: /Action.mainCoordinator) {
            MainCoordinator()
        }
        
        Reduce { state, action in
            switch action {
            case .mainCoordinator(.logout):
                return .send(.switchTab(.login))
            case .switchTab(let tab):
                state.currentTab = tab
            case .login(.login):
                return .send(.switchTab(.home))
            default:
                break
            }
            return .none
        }
    }
}
