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
            VStack(spacing: Keys.Padding.px8) {
                titleText
                
                PlainList(spacing: Keys.Padding.px8, horizontalPadding: Keys.Padding.px12) {
                    if store.areMealsLoading {
                        loadingSpinner
                    } else if store.hasError {
                        retrySection
                    } else if !store.meals.isEmpty {
                        ForEach(store.meals, id: \.self) { meal in
                            TodayMealCardView(meal: meal) {
                                store.send(.selectMeal(meal))
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                deleteButton(uuid: meal.id)
                            }
                        }
                        
                    } else {
                        emptyText
                    }
                }
                .maxFrame()
                .animation(.default, value: store.meals)
                .animation(.default, value: store.areMealsLoading)
                .refreshable {
                    // Swipe to refresh
                    store.send(.loadMeals)
                }
            }
            .padding(.top, Keys.Padding.px12)
        }
        .maxFrame()
        .overlay {
            floatingButtonOverlay
        }
        .sheet(isPresented: $store.isAddFoodShowing) {
            FoodSheetCoordinatorView(store: store.scope(state: \.foodPopover, action: \.foodPopover))
        }
        .sheet(item: $store.updateMeal) { _ in
            IfLetStore(store.scope(state: \.updateMeal, action: \.updateMeal)) { store in
                UpdateMealSheetView(store: store)
            }
        }
        .task {
            // Pull new meals on initial load (is okay if niche cases call an additional call)
            if store.areMealsLoading && store.meals.isEmpty {
                store.send(.loadMeals)
            }
        }
    }
    
    @ViewBuilder
    private func deleteButton(uuid: UUID) -> some View {
        Button(role: .destructive) {
            store.send(.deleteMeal(uuid))
        } label: {
            Image(systemName: Keys.SystemIcon.TRASH)
        }
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
            .padding()
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
