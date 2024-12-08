//
//  Today.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI
import FirebaseCore

@Reducer
public struct Today {
    
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    public struct State: Equatable {
        public var foodPopover: FoodSheetCoordinator.State = .init()
        public var updateMeal: UpdateMealSheet.State?
        
        public var isAddFoodShowing = false
        public var areMealsLoading = true
        public var hasError = false
        public var meals: [MacroMeal] = .init()
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectMeal(MacroMeal)
        case loadMeals
        case loadMealsResponse([MacroMeal])
        case error(Error)
        case updateMeal(UpdateMealSheet.Action)
        case foodPopover(FoodSheetCoordinator.Action)
        case showFoodPopover
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.foodPopover, action: \.foodPopover) {
            FoodSheetCoordinator()
        }

        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .selectMeal(let meal):
                // Present Sheet
                state.updateMeal = .init(meal: meal)
            case .updateMeal(.saved):
                // Dismiss Sheet
                state.updateMeal = nil
            case .showFoodPopover:
                state.foodPopover = .init()
                state.isAddFoodShowing = true
            case .foodPopover(.path(.element(_, .manualEntry(.saved)))):
                state.isAddFoodShowing = false
                return .send(.loadMeals)
            case .loadMeals:
                state.areMealsLoading = true
                state.hasError = false
                return .run { send in
                    do {
                        try await send(.loadMealsResponse(apiClient.getDayMeals(.init())))
                    } catch {
                        await send(.error(error))
                    }
                }
            case .loadMealsResponse(let meals):
                state.areMealsLoading = false
                state.meals = meals
            case .error:
                state.areMealsLoading = false
                state.hasError = true
            default:
                break
            }
            return .none
        }
        .ifLet(\.updateMeal, action: \.updateMeal) {
            UpdateMealSheet()
        }
    }
}

