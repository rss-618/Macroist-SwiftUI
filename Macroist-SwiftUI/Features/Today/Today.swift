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
    
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    public struct State: Equatable {
        public var addFoodState: AddMealHome.State = .init()
        public var isAddFoodShowing = false
        public var areMealsLoading = false
        public var meals: [MacroMeal] = .init()
    }
    
    public enum Action: BindableAction {
        case showAddFoodPopover
        case addFood(AddMealHome.Action)
        case binding(BindingAction<State>)
        case loadMeals
        case loadMealsResponse([MacroMeal]?)
        case error(Error)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.addFoodState, action: /Action.addFood) {
            AddMealHome()
        }
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .loadMeals:
                state.areMealsLoading = true
                return .run { send in
                    do {
                        try await send(.loadMealsResponse(apiClient.getDayMeals(.init())))
                    } catch {
                        await send(.error(error))
                    }
                }
            case .loadMealsResponse(let meals):
                state.areMealsLoading = false
                state.meals = meals ?? []
            case .error(let error):
                state.areMealsLoading = false
                print(error)
            default:
                break
            }
            return .none
        }
    }
}

