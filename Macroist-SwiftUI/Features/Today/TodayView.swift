//
//  TodayView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/11/24.
//

import ComposableArchitecture
import SwiftUI

public struct TodayView: View {
    
    @Perception.Bindable var store: StoreOf<Today>
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                // Background View
                GenericBackgroundView()
                
                // Content
                VStack {
                    Text("Today View")
                }
                
                // Floating Icon
                FloatingButton(iconName: Keys.SystemIcon.PLUS) {
                    store.send(.binding(.set(\.isAddFoodShowing, true)))
                }
                .padding(Keys.Padding.dp32)
                .align(x: .trailing, y: .bottom)
            }
            .popover(isPresented: $store.isAddFoodShowing) {
                FoodPopoverCoordinatorView(store: Store(initialState: FoodPopoverCoordinator.State()) {
                    FoodPopoverCoordinator()
                })
            }
        }
    }
    
    public init(store: StoreOf<Today>) {
        self.store = store
    }
    
}
