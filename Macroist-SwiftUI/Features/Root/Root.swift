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
        public var currentTab: Page = .login
        public var loginState: Login.State = .init()
        public var homeState: Home.State = .init()
    }

    public enum Page: Equatable {
        case login
        case home
    }
    
    public enum Action {
        case login(Login.Action)
        case home(Home.Action)
        case logout
        case switchTab(Page)
        case resetStates
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.loginState, action: \.login) {
            Login()
        }
        
        Scope(state: \.homeState, action: \.home) {
            Home()
        }
        
        Reduce { state, action in
            switch action {
            case .home(.logout):
                return .concatenate(.send(.resetStates),
                                    .send(.switchTab(.login)))
            case .login(.login):
                return .concatenate(.send(.resetStates),
                                    .send(.switchTab(.home)))
            case .switchTab(let tab):
                state.currentTab = tab
            case .resetStates:
                state.loginState = .init()
                state.homeState = .init()
            default:
                break
            }
            return .none
        }
    }
}
