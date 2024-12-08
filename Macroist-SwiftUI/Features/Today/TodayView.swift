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
            VStack(spacing: .zero) {
                titleText
                    .padding(.vertical, Keys.Padding.px8)
                
                ScrollView {
                    LazyVStack {
                        if store.areMealsLoading {
                            loadingSpinner
                        } else if store.hasError {
                            retrySection
                        } else if !store.meals.isEmpty {
                            ForEachStore(store.scope(state: \.meals, action: \.meals)) { store in
                                TodayMealCardView(store: store)
                            }
                        } else {
                            emptyText
                        }
                    } // End VStack
                    .maxFrame()
                    .padding()
                    .animation(.default, value: store.meals)
                    .animation(.default, value: store.areMealsLoading)
                }
                .refreshable {
                    // Swipe to refresh
                    store.send(.loadMeals)
                }
            }
        }
        .overlay {
            floatingButtonOverlay
        }
        .popover(isPresented: $store.isAddFoodShowing) {
            FoodPopoverCoordinatorView(store: store.scope(state: \.foodPopover, action: \.foodPopover))
        }
        .task {
            // Pull new meals on initial load (is okay if niche cases call an additional call)
            if store.areMealsLoading && store.meals.isEmpty {
                store.send(.loadMeals)
            }
        }
        .animation(.easeIn, value: store.areMealsLoading)
        .animation(.default, value: store.meals)
    }
    
    private var loadingSpinner: some View {
        ProgressView()
            .controlSize(.large)
            .align()
            .maxFrame()
    }
    
    private var emptyText: some View {
        Text("No meals.")
            .font(.headline)
    }
    
    private var titleText: some View {
        Text("Today's Food")
            .font(.largeTitle)
    }
    
    private var retrySection: some View {
        VStack {
            Text("Uh Oh!")
                .font(.title)
            Text("Something went wrong. Please Try again.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button {
                store.send(.loadMeals)
            } label: {
                Text("Retry")
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    private var floatingButtonOverlay: some View {
        // Floating Icon
        FloatingButton(iconName: Keys.SystemIcon.PLUS) {
            store.send(.showFoodPopover)
        }
        .padding(Keys.Padding.px32)
        .align(x: .trailing, y: .bottom)
    }
    
    public init(store: StoreOf<Today>) {
        self.store = store
    }
    
}
