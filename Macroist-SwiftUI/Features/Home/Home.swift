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
        public var todayState: Today.State = .init()
        
        public var currentTab: Tab = .today
    }
    
    public enum Action: Equatable, BindableAction {
        case logout
        case binding(BindingAction<State>)
        case today(Today.Action)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.todayState, action: /Action.today) {
            Today()
        }
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            default:
                break
            }
            return .none
        }
    }
}
