//
//  FoodPopoverCoordinator.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct FoodPopoverCoordinator {
    
    @ObservableState
    public struct State {
        public var path = StackState<Path.State>()
        public var home: AddMealHome.State = .init()
    }
    
    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case home(AddMealHome.Action)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.home, action: /Action.home) {
            AddMealHome()
        }
        
        Reduce { state, action in
            switch action {
            case .home(.manualEntry):
                state.path.append(.manualEntry(.init()))
            default:
                break
            }
            return .none
        }.forEach(\.path, action: \.path) {
            Path()
        }
    }
    
}
