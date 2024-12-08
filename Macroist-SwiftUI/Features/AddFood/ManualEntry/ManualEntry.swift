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
    
    @ObservableState
    public struct State: Equatable {
        var mealNameInput: InputField.State = .init(placeholder: "Meal Name")
        var ingredientCards: IdentifiedArrayOf<IngredientEntryCard.State> = [.init()]
    }
    
    public enum Action: Equatable {
        case mealNameInput(InputField.Action)
        case ingredientCards(IdentifiedActionOf<IngredientEntryCard>)
        case addIngredient
        case savePressed
        case validateInput
        case createMeal
        case attemptSave(MacroMeal)
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
                state.ingredientCards.append(.init())
            case .savePressed:
                return .send(.validateInput)
            case .validateInput:
                return .run { [state] send in
                    for id in state.ingredientCards.ids {
                        // Process all ingredients
                        await send.callAsFunction(.ingredientCards(.element(id: id, action: .process)))
                    }
                    
                    await send.callAsFunction(.createMeal)
                }
            case .createMeal:
                var ingredients: [Ingredient] = .init()
                for cardState in state.ingredientCards.elements {
                    guard let ingredient = cardState.ingredient, !cardState.hasError else {
                        return .none // TODO: Create Error Alert
                    }
                    ingredients.append(ingredient)
                }
                let macroFood = MacroMeal(mealName: state.mealNameInput.text.trimWhiteSpaceAndNewline(),
                                          ingredients: ingredients)
                return .send(.attemptSave(macroFood))
            case .attemptSave(let meal):
                return .run { send in
                    do {
                        try await apiClient.addMeal(meal)
                        await send(.saved)
                    } catch {
                        await send(.error)
                    }
                }
            case .saved:
                print("saved it")
            case .error:
                print("couldnt")
            default:
                break
            }
            return .none
        }.forEach(\.ingredientCards, action: \.ingredientCards) {
            IngredientEntryCard()
        }
    }
}
