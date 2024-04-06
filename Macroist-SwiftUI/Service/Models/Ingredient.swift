//
//  Ingredient.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/15/24.
//

import Foundation

public struct Ingredient: Codable, Equatable, Hashable {
    
    public let id: UUID
    public var name: String
    public var calories: CGFloat
    public var protein: CGFloat
    public var carbs: CGFloat
    public var fat: CGFloat
    
    public init(id: UUID = .init(),
                name: String = .init(),
                calories: CGFloat = .zero,
                protein: CGFloat = .zero,
                carbs: CGFloat = .zero,
                fat: CGFloat = .zero) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
}
