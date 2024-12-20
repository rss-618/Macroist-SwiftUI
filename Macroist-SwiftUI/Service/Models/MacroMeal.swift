//
//  MacroMeal.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//
// User-Defined Food Object to Provide a Common Object Between API and Custom Food

import Foundation
import FirebaseCore
import FirebaseFirestore

public struct MacroMeal: Equatable, Hashable, Codable {
        
    public var mealName: String
    public var ingredients: [Ingredient] {
        didSet {
            calculateFields(ingredients)
        }
    }
    public var dateKey: DateEntryKey {
        .init(Date(timeIntervalSince1970: Double(timeStamp.seconds)))
    }
    
    // Computed Values
    public private(set) var id: UUID
    public private(set) var timeStamp: Timestamp = .init()
    public private(set) var calories: CGFloat = .zero
    public private(set) var protein: CGFloat = .zero
    public private(set) var carbs: CGFloat = .zero
    public private(set) var fat: CGFloat = .zero
    
    public init(id: UUID,
                dateKey: DateEntryKey = .init(),
                mealName: String = .init(),
                ingredients: [Ingredient] = [.init(id: UUID())]) {
        self.id = id
        self.timeStamp = Timestamp(date: dateKey.date)
        self.mealName = mealName
        self.ingredients = ingredients
        self.calculateFields(ingredients)
    }
    
    fileprivate mutating func calculateFields(_ ingredients: [Ingredient]) {
        calories = .zero
        protein = .zero
        carbs = .zero
        fat = .zero
        ingredients.forEach { ingredient in
            calories += ingredient.calories
            protein += ingredient.protein
            carbs += ingredient.carbs
            fat += ingredient.fat
        }
    }
        
    // TODO: Provide convenience init(s) and functions to provide commonality between USADA API
    // https://fdc.nal.usda.gov/api-spec/fdc_api.html#/
}
