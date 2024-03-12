//
//  Today.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct Today {
    
    @ObservableState
    public struct State: Equatable {
        public var addFoodState: AddFoodPopover.State = .init()
        public var isAddFoodShowing = false
    }
    
    public enum Action: Equatable, BindableAction{
        case showAddFoodPopover
        case addFood(AddFoodPopover.Action)
        case binding(BindingAction<State>)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.addFoodState, action: /Action.addFood) {
            AddFoodPopover()
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

