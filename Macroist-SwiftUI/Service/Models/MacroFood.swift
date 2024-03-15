//
//  MacroFood.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//
// User-Defined Food Object to Provide a Common Object Between API and Custom Food

import Foundation
import FirebaseCore
import FirebaseFirestore

public struct MacroFood: Equatable, Hashable, Codable {
    
    public var mealName: String
    public var timeStamp: Timestamp
    public var calories: CGFloat
    public var protein: CGFloat
    public var carbs: CGFloat
    public var fat: CGFloat
    
    public init(mealName: String,
                timeStamp: Timestamp = .init(),
                calories: CGFloat = .zero,
                protein: CGFloat = .zero,
                carbs: CGFloat = .zero,
                fat: CGFloat = .zero) {
        self.mealName = mealName
        self.timeStamp = timeStamp
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
    
    // TODO: Provide convenience init(s) and functions to provide commonality between USADA API
    // https://fdc.nal.usda.gov/api-spec/fdc_api.html#/
}
