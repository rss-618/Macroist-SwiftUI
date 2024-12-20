//
//  ManualEntry.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct MealEntry {
    
    @Dependency(\.apiClient) var apiClient
    
    public enum Variant: Equatable {
        case new
        case edit
        
        public var title: String {
            switch self {
            case .new:
                "Manual Entry"
            case .edit:
                "Meal"
            }
        }
    }
    
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: UUID {
            initialMeal.id
        }
        let variant: Variant
        let initialMeal: MacroMeal
        var isEditing: Bool
        var mealNameInput: InputField.State
        var ingredientCards: IdentifiedArrayOf<IngredientEntryCard.State>
        
        public init(variant: Variant, meal: MacroMeal = .init(id: UUID())) {
            self.variant = variant
            self.initialMeal = meal
            let isEditing = variant == .new
            let ingredientVariant: IngredientEntryCard.Variant = isEditing ? .edit : .read
            self.isEditing = isEditing
            self.mealNameInput = .init(text: meal.mealName, placeholder: "Meal Name")
            self.ingredientCards = .init(uniqueElements: meal.ingredients.compactMap { .init(variant: ingredientVariant,
                                                                                             ingredient: $0) })
        }
        
        public mutating func resetInputs() {
            let ingredientVariant: IngredientEntryCard.Variant = isEditing ? .edit : .read
            self.mealNameInput = .init(text: initialMeal.mealName, placeholder: "Meal Name")
            self.ingredientCards = .init(uniqueElements: initialMeal.ingredients.compactMap { .init(variant: ingredientVariant,
                                                                                                    ingredient: $0) })
        }
        
        public mutating func getMeal() throws -> MacroMeal {
            var ingredients: [Ingredient] = .init()
            for index in ingredientCards.indices {
                try ingredients.append(ingredientCards[index].getIngredient())
            }
            return MacroMeal(id: initialMeal.id,
                             dateKey: initialMeal.dateKey,
                             mealName: mealNameInput.text,
                             ingredients: ingredients)
        }
    }
    
    public enum Action: Equatable {
        case toggleEditing
        case mealNameInput(InputField.Action)
        case ingredientCards(IdentifiedActionOf<IngredientEntryCard>)
        case addIngredient
        case savePressed
        case updatePressed
        case saved
        case error
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.mealNameInput, action: \.mealNameInput) {
            InputField()
        }
        
        Reduce { state, action in
            switch action {
            case .toggleEditing:
                if state.isEditing {
                    state.resetInputs()
                }
                state.isEditing.toggle()
            case .addIngredient:
                state.ingredientCards.append(.init(variant: .edit))
            case .savePressed:
                guard let meal = try? state.getMeal() else {
                    return .send(.error)
                }
                return .run { send in
                    do {
                        try await apiClient.addMeal(meal)
                        await send(.saved)
                    } catch {
                        // API Error
                        await send(.error)
                    }
                }
            case .updatePressed:
                guard let meal = try? state.getMeal() else {
                    return .send(.error)
                }
                return .run { send in
                    do {
                        try await apiClient.updateMeal(meal)
                        await send(.saved)
                    } catch {
                        // API Error
                        await send(.error)
                    }
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
