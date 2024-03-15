//
//  Home.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct Home {
    
    @ObservableState
    public struct State: Equatable {
        public var historyState: History.State = .init()
        public var todayState: Today.State = .init()
        public var settingsState: Settings.State = .init()
        
        public var currentTab: Tab = .today
    }
    
    public enum Action: Equatable, BindableAction {
        case logout
        case binding(BindingAction<State>)
        case history(History.Action)
        case today(Today.Action)
        case settings(Settings.Action)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.historyState, action: /Action.history) {
            History()
        }
        
        Scope(state: \.todayState, action: /Action.today) {
            Today()
        }
        
        Scope(state: \.settingsState, action: /Action.settings) {
            Settings()
        }
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .settings(.logout):
                return .send(.logout)
            default:
                break
            }
            return .none
        }
    }
}
