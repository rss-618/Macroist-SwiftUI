//
//  FoodPopoverPath.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation

extension FoodSheetCoordinator {
    
    @Reducer
    public struct Path {
        
        @ObservableState
        public enum State: Equatable {
            case mealEntry(MealEntry.State)
        }
        
        public enum Action {
            case mealEntry(MealEntry.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.mealEntry, action: \.mealEntry) {
                MealEntry()
            }
        }
    }
    
}
