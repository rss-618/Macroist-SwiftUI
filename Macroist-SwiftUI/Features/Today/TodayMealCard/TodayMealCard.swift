//
//  TodayMealCard.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 4/5/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct TodayMealCard {
    
    @ObservableState
    public struct State: Equatable, Identifiable {
        public let id: UUID
        var meal: MacroMeal
        
        public init(meal: MacroMeal) {
            self.id = meal.id
            self.meal = meal
        }
    }
    
    public enum Action: Equatable {
        case openMeal
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                break
            }
            return .none
        }
    }
}
