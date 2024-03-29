//
//  FoodPopoverCoordinatorView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import SwiftUI

public struct FoodPopoverCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<FoodPopoverCoordinator>

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                NavigationStack(
                    path: $store.scope(state: \.path, action: \.path)
                ) {
                    // Root view of the navigation stack
                    AddMealHomeView(store: store.scope(state: \.home, action: \.home))
                } destination: { store in
                    switch store.state {
                    case .manualEntry:
                        ManualEntryView(store: store.scope(state: \.manualEntry, action: \.manualEntry))
                    }
                }
            }
        }
    }
}
