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
        public var addFoodState: AddMealHome.State = .init()
        public var isAddFoodShowing = false
    }
    
    public enum Action: Equatable, BindableAction{
        case showAddFoodPopover
        case addFood(AddMealHome.Action)
        case binding(BindingAction<State>)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.addFoodState, action: /Action.addFood) {
            AddMealHome()
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

