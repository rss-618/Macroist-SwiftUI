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
                
                totalView(totalMeals: store.meals)
                
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
        .sheet(item: $store.addFood) { _ in
            IfLetStore(store.scope(state: \.addFood, action: \.addFood)) { store in
                FoodSheetCoordinatorView(store: store)
            }
        }
        .sheet(item: $store.updateMeal) { _ in
            IfLetStore(store.scope(state: \.updateMeal, action: \.updateMeal)) { store in
                // Included the navigation view to be able to use `.navigationTitle()`
                NavigationView {
                    MealEntryView(store: store)
                }
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
    private func totalView(totalMeals: [MacroMeal]) -> some View {
        HStack {
            totalCell(title: "Calories",
                      total: totalMeals.reduce(.zero) {
                $0 + $1.calories
            },
                      color: .red)
            totalCell(title: "Protein",
                      total: totalMeals.reduce(.zero) {
                $0 + $1.protein
            },
                      color: .green)
            totalCell(title: "Carbs",
                      total: totalMeals.reduce(.zero) {
                $0 + $1.carbs
            },
                      color: .blue)
            totalCell(title: "Fat",
                      total: totalMeals.reduce(.zero) {
                $0 + $1.fat
            },
                      color: .yellow)
        }
    }
    
    @ViewBuilder
    func totalCell(title: String, total: CGFloat, color: Color) -> some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.ultraLight)
            
            Text(String(format: "%.2f", total))
                .font(.subheadline)
        }
        .padding(Keys.Padding.px2)
        .padding(.horizontal, Keys.Padding.px2)
        .background {
            RoundedRectangle(cornerRadius: Keys.CornerRadius.px10)
                .fill(color.opacity(Keys.Opactiy.pct33))
                .overlay {
                    RoundedRectangle(cornerRadius: Keys.CornerRadius.px10)
                        .stroke(lineWidth: Keys.Width.px1)
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
