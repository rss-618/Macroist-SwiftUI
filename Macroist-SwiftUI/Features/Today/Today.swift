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
        public var foodPopover: FoodPopoverCoordinator.State = .init()
        public var isAddFoodShowing = false
        public var areMealsLoading = true
        public var hasError = false
        public var meals: IdentifiedArrayOf<TodayMealCard.State> = .init()
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loadMeals
        case loadMealsResponse([MacroMeal])
        case error(Error)
        case meals(IdentifiedActionOf<TodayMealCard>)
        case foodPopover(FoodPopoverCoordinator.Action)
        case showFoodPopover
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.foodPopover, action: \.foodPopover) {
            FoodPopoverCoordinator()
        }

        BindingReducer()
        
        Reduce { state, action in
            switch action {
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
                state.meals = IdentifiedArray(uniqueElements: meals.map {
                    TodayMealCard.State(meal: $0)
                })
            case .error:
                state.areMealsLoading = false
                state.hasError = true
            default:
                break
            }
            return .none
        }.forEach(\.meals, action: \.meals) {
            TodayMealCard()
        }
    }
}

