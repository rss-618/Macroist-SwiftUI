//
//  MainCoordinator.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MainCoordinator {
    
    @ObservableState
    public struct State: Equatable {
        
        public static func == (lhs: MainCoordinator.State, rhs: MainCoordinator.State) -> Bool {
            return lhs.path.ids == rhs.path.ids && lhs.home == rhs.home
        }
        
        var path = StackState<Path.State>()
        var home: Home.State = .init()
    }
    
    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case home(Home.Action)
        case logout // parent call
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.home, action: /Action.home) {
            Home()
        }
        
        Reduce { state, action in
            switch action {
            case .home(.logout):
                return .send(.logout)
            case .path(.element(_, action: .home(.logout))):
                return .send(.logout)
            default:
                break
            }
            return .none
        }.forEach(\.path, action: \.path) {
            Path()
        }
    }
    
}
