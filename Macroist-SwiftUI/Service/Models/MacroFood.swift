//
//  MacroFood.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//
// User-Defined Food Object to Provide a Common Object Between API and Custom Food

import Foundation

public struct MacroFood: Equatable, Codable {
    public var name: String
    public var grams: CGFloat
    public var calories: CGFloat
    public var protein: CGFloat
    public var carbs: CGFloat
    public var fat: CGFloat
    
    // TODO: Provide convenience init(s) and functions to provide commonality between USADA API
    // https://fdc.nal.usda.gov/api-spec/fdc_api.html#/
}
