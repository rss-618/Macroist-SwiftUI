//
//  FoodPopoverCoordinator.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct FoodSheetCoordinator {
        
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: UUID
        var path = StackState<Path.State>()
        var home: AddMealHome.State = .init()
        
        public init(_ id: UUID = .init()) {
            self.id = id
        }
    }
    
    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case home(AddMealHome.Action)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.home, action: \.home) {
            AddMealHome()
        }
        
        Reduce { state, action in
            switch action {
            case .home(.mealEntry):
                state.path.append(.mealEntry(.init(variant: .new)))
            default:
                break
            }
            return .none
        }.forEach(\.path, action: \.path) {
            Path()
        }
    }
    
}
