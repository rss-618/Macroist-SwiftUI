//
//  UpdateMealSheet.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 12/8/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct UpdateMealSheet {
        
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: UUID {
            UUID(meal.mealName.hashValue)
        }
        let meal: MacroMeal
    }
    
    public enum Action {
        case save
        case saved
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .save:
                break
            default:
                break
            }
            return .none
        }
    }
    
}
