//
//  IngredientEntryCard.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/15/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct IngredientEntryCard {
    
    @ObservableState
    public struct State: Equatable, Identifiable {
        
        public var id = UUID()
        
        public var hasError: Bool {
            name.inputState == .error
            || calories.inputState == .error
            || carbs.inputState == .error
            || protein.inputState == .error
            || fat.inputState == .error
        }
        
        var name: InputField.State = .init(placeholder: "Ingredient Name (Optional)")
        var calories: InputField.State = .init(placeholder: "Calories")
        var carbs: InputField.State = .init(placeholder: "Protein (Optional)")
        var protein: InputField.State = .init(placeholder: "Carbs (Optional)")
        var fat: InputField.State = .init(placeholder: "Fat (Optional)")
        
        public var ingredient: Ingredient?
    }
    
    public enum Action: Equatable {
        case name(InputField.Action)
        case calories(InputField.Action)
        case carbs(InputField.Action)
        case protein(InputField.Action)
        case fat(InputField.Action)
        
        case process
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.name, action: \.name) {
            InputField()
        }
        Scope(state: \.calories, action: \.calories) {
            InputField()
        }
        Scope(state: \.carbs, action: \.carbs) {
            InputField()
        }
        Scope(state: \.protein, action: \.protein) {
            InputField()
        }
        Scope(state: \.fat, action: \.fat) {
            InputField()
        }
        
        Reduce { state, action in
            switch action {
            case .process:
                let name: String = state.name.text.trimWhiteSpaceAndNewline()
                var calories: CGFloat = .init()
                var carbs: CGFloat = .init()
                var protein: CGFloat = .init()
                var fat: CGFloat = .init()
                
                // Calories
                if !state.calories.text.trimWhiteSpaceAndNewline().isEmpty,
                   let val = state.calories.text.trimWhiteSpaceAndNewline().toCGFloat() {
                    calories = val
                } else {
                    state.calories.inputState = .error
                }
                // Carbs
                if let val = state.carbs.text.trimWhiteSpaceAndNewline().toCGFloat() {
                    carbs = val
                } else {
                    state.carbs.inputState = .error
                }
                // Protein
                if let val = state.protein.text.trimWhiteSpaceAndNewline().toCGFloat() {
                    protein = val
                } else {
                    state.protein.inputState = .error
                }
                // Fat
                if let val = state.fat.text.trimWhiteSpaceAndNewline().toCGFloat() {
                    fat = val
                } else {
                    state.fat.inputState = .error
                }
                
                if !state.hasError {
                    state.ingredient = Ingredient(name: name,
                                                  calories: calories,
                                                  protein: protein,
                                                  carbs: carbs,
                                                  fat: fat)
                }
            default:
                break
            }
            return .none
        }
        
    }
}
