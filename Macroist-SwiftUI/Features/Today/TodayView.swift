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
                VStack {
                    Text("Today's Food")
                        .font(.largeTitle)
                    
                    ScrollView {
                        VStack {
                            ForEachStore(store.scope(state: \.meals, action: \.meals)) { store in
                                TodayMealCardView(store: store)
                            }
                            .opacity(store.areMealsLoading ? .zero : Keys.Opactiy.pct100)
                        } // End VStack
                        .maxFrame()
                        .padding()
                        
                    } // End Scroll View
                    .background(Color.white)
                }
                
                // Loading Icon
                ProgressView()
                    .controlSize(.large)
                    .align()
                    .maxFrame()
                    .opacity(store.areMealsLoading ? Keys.Opactiy.pct100 : .zero)
                // Floating Icon
                FloatingButton(iconName: Keys.SystemIcon.PLUS) {
                    store.send(.showFoodPopover)
                }
                .padding(Keys.Padding.dp32)
                .align(x: .trailing, y: .bottom)
            }
            .popover(isPresented: $store.isAddFoodShowing) {
                FoodPopoverCoordinatorView(store: store.scope(state: \.foodPopover, action: \.foodPopover))
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
        .animation(.easeIn, value: store.areMealsLoading)
        .animation(.default, value: store.meals)
    }
    
    public init(store: StoreOf<Today>) {
        self.store = store
    }
    
}
