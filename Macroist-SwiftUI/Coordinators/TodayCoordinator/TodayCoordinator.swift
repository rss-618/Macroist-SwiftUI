//
//  TodayCoordinator.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/22/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TodayCoordinator {
    
    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        public var today: Today.State = .init()
    }
    
    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case today(Today.Action)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.today, action: /Action.today) {
            Today()
        }
        
        Reduce { state, action in
            switch action {
            default:
                break
            }
            return .none
        }.forEach(\.path, action: \.path) {
            Path()
        }
    }
    
}
