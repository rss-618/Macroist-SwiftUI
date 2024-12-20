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
    
    public enum Variant: Equatable {
        case read
        case edit
    }
    
    @ObservableState
    public struct State: Equatable, Identifiable {
        
        public var id: UUID
        
        var variant: Variant
        var name: InputField.State = .init(placeholder: "Ingredient Name (Optional)")
        var calories: InputField.State = .init(placeholder: "Calories")
        var protein: InputField.State = .init(placeholder: "Protein (Optional)")
        var carbs: InputField.State = .init(placeholder: "Carbs (Optional)")
        var fat: InputField.State = .init(placeholder: "Fat (Optional)")
        
        public init(variant: Variant, ingredient: Ingredient = .init(id: UUID())) {
            self.variant = variant
            self.id = ingredient.id
            self.name.text = ingredient.name
            self.calories.text = ingredient.calories.nonZeroString
            self.protein.text = ingredient.protein.nonZeroString
            self.carbs.text = ingredient.carbs.nonZeroString
            self.fat.text = ingredient.fat.nonZeroString
        }
        
        public var hasError: Bool {
            name.inputState == .error
            || calories.inputState == .error
            || carbs.inputState == .error
            || protein.inputState == .error
            || fat.inputState == .error
        }
        
        public mutating func getIngredient() throws -> Ingredient {
            let name: String = name.text.trimWhiteSpaceAndNewline()
            var calories: CGFloat = .init()
            var carbs: CGFloat = .init()
            var protein: CGFloat = .init()
            var fat: CGFloat = .init()
            
            // Calories
            if !self.calories.text.trimWhiteSpaceAndNewline().isEmpty,
               let val = self.calories.text.trimWhiteSpaceAndNewline().toCGFloat() {
                calories = val
            } else {
                self.calories.inputState = .error
            }
            // Carbs
            if let val = self.carbs.text.trimWhiteSpaceAndNewline().toCGFloat() {
                carbs = val
            } else {
                self.carbs.inputState = .error
            }
            // Protein
            if let val = self.protein.text.trimWhiteSpaceAndNewline().toCGFloat() {
                protein = val
            } else {
                self.protein.inputState = .error
            }
            // Fat
            if let val = self.fat.text.trimWhiteSpaceAndNewline().toCGFloat() {
                fat = val
            } else {
                self.fat.inputState = .error
            }
            
            guard !self.hasError else {
                throw AppError.technicalError
            }
            
            return Ingredient(id: id,
                              name: name,
                              calories: calories,
                              protein: protein,
                              carbs: carbs,
                              fat: fat)
            
        }
    }
    
    public enum Action: Equatable {
        case name(InputField.Action)
        case calories(InputField.Action)
        case carbs(InputField.Action)
        case protein(InputField.Action)
        case fat(InputField.Action)
                
        case remove
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
        
        EmptyReducer()
    }
}
