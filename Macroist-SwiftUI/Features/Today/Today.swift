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
        public var updateMeal: MealEntry.State?
        
        public var isAddFoodShowing = false
        public var areMealsLoading = true
        public var hasError = false
        var _meals: [MacroMeal] = .init()
        private var pendingDeletions: [UUID] = .init()
        
        public var meals: [MacroMeal] {
            _meals.filter { !pendingDeletions.contains($0.id) }
        }
        
        mutating func pendingDelete(_ uuid: UUID) {
            pendingDeletions.append(uuid)
        }
        
        mutating func deleteFailure(_ uuid: UUID) {
            pendingDeletions.removeAll {
                $0 == uuid
            }
        }
        
        mutating func deleteSuccess(_ uuid: UUID) {
            pendingDeletions.removeAll {
                $0 == uuid
            }
            _meals.removeAll {
                $0.id == uuid
            }
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectMeal(MacroMeal)
        case deleteMeal(UUID)
        case deleteFailure(UUID)
        case deleteSuccess(UUID)
        case loadMeals
        case loadMealsResponse([MacroMeal])
        case error(Error)
        case updateMeal(MealEntry.Action)
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
                state.updateMeal = .init(variant: .edit, meal: meal)
            case .deleteMeal(let uuid):
                state.pendingDelete(uuid)
                return .run { send in
                    do {
                        try await apiClient.deleteTodaysMeal(uuid)
                        await send(.deleteSuccess(uuid))
                    } catch {
                        await send(.deleteFailure(uuid))
                    }
                }
            case .deleteSuccess(let uuid):
                state.deleteSuccess(uuid)
            case .deleteFailure(let uuid):
                state.deleteFailure(uuid)
            case .updateMeal(.saved):
                // Dismiss Sheet
                state.updateMeal = nil
            case .showFoodPopover:
                state.foodPopover = .init()
                state.isAddFoodShowing = true
            case .foodPopover(.path(.element(_, .mealEntry(.saved)))):
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
                state._meals = meals
            case .error:
                state.areMealsLoading = false
                state.hasError = true
            default:
                break
            }
            return .none
        }
        .ifLet(\.updateMeal, action: \.updateMeal) {
            MealEntry()
        }
    }
}

