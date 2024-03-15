//
//  History.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/14/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct History {
    
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    public struct State: Equatable {
        public var meals: [MacroFood]?
    }
    
    public enum Action: Equatable {
        case loadFood
        case loadFoodResponse([MacroFood]?)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadFood:
                return .run { send in
                    do {
                        try await send(.loadFoodResponse(apiClient.getMonthMeals(.init())))
                    } catch {
                        print(error)
                    }
                }
            case .loadFoodResponse(let meals):
                state.meals = meals
            default:
                break
            }
            return .none
        }
    }
}
