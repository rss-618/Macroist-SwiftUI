//
//  FoodPopoverCoordinatorView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import SwiftUI

public struct FoodSheetCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<FoodSheetCoordinator>

    public var body: some View {
        WithPerceptionTracking {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path)
            ) {
                // Root view of the navigation stack
                AddMealHomeView(store: store.scope(state: \.home, action: \.home))
            } destination: { store in
                switch store.state {
                case .mealEntry:
                    if let mealEntryStore = store.scope(state: \.mealEntry, action: \.mealEntry) {
                        MealEntryView(store: mealEntryStore)
                    }
                }
            }
        }
    }
}
