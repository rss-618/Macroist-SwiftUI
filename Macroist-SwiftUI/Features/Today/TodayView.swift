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
                ScrollView {
                    VStack {
                        Text("Today's Food")
                            .font(.largeTitle)
                        // TOOD: needs real UI
                        if store.areMealsLoading {
                            ProgressView()
                                .align()
                        } else {
                            ForEach(store.meals, id: \.self) { meal in
                                VStack {
                                    Text(meal.mealName)
                                    Text("Calories \(meal.calories)")
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding()
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
            .task {
                store.send(.loadMeals)
            }
            .onChange(of: store.isAddFoodShowing) { new in
                // TODO: Figure out how to listen to this in the reducer with the new style things
                if !new {
                    store.send(.loadMeals)
                }
            }
        }
    }
    
    public init(store: StoreOf<Today>) {
        self.store = store
    }
    
}
