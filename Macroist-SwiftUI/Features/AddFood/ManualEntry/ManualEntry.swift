//
//  ManualEntry.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct ManualEntry {
    
    @Dependency(\.apiClient) var apiClient
    
    public enum Variant: Equatable {
        case new
        case edit(MealEdit)
    }
    
    public struct MealEdit: Equatable {
        var isReadOnly = true
        var meal: MacroMeal
    }
    
    @ObservableState
    public struct State: Equatable {
        var variant: Variant
        var mealNameInput: InputField.State = .init(placeholder: "Meal Name")
        var ingredientCards: IdentifiedArrayOf<IngredientEntryCard.State> = [.init(variant: .edit)]
        
        public mutating func getIngredients() throws -> [Ingredient] {
            var ingredients: [Ingredient] = .init()
            for index in ingredientCards.indices {
                try ingredients.append(ingredientCards[index].getIngredient())
            }
            return ingredients
        }
    }
    
    public enum Action: Equatable {
        case mealNameInput(InputField.Action)
        case ingredientCards(IdentifiedActionOf<IngredientEntryCard>)
        case addIngredient
        case savePressed
        case saved
        case error
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.mealNameInput, action: \.mealNameInput) {
            InputField()
        }
        
        Reduce { state, action in
            switch action {
            case .addIngredient:
                state.ingredientCards.append(.init(variant: .edit))
            case .savePressed:
                do {
                    // Attempt to build meal
                    let meal = try MacroMeal(mealName: state.mealNameInput.text,
                                              ingredients: state.getIngredients())
                    // Build is successful
                    return .run { send in
                        do {
                            try await apiClient.addMeal(meal)
                            await send(.saved)
                        } catch {
                            // API Error
                            await send(.error)
                        }
                    }
                } catch {
                    // Parsing Error
                    return .send(.error)
                }
            case .saved:
                print("saved it")
            case .error:
                print("couldnt")
            case .ingredientCards(.element(let id, action: .remove)):
                state.ingredientCards.removeAll {
                    $0.id == id
                }
            default:
                break
            }
            return .none
        }.forEach(\.ingredientCards, action: \.ingredientCards) {
            IngredientEntryCard()
        }
    }
}
