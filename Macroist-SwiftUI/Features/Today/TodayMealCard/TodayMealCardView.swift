//
//  TodayMealCardView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 4/5/24.
//

import ComposableArchitecture
import SwiftUI

public struct TodayMealCardView: View {
    
    @Perception.Bindable var store: StoreOf<TodayMealCard>

    public var body: some View {
        WithPerceptionTracking {
            Button {
                store.send(.openMeal)
            } label: {
                VStack {
                    title
                    
                    HStack {
                        textBlock(title: "Calories",
                                  body: store.meal.calories.roundToString(Keys.Points.p2))
                        
                        textBlock(title: "Protein",
                                  body: store.meal.protein.roundToString(Keys.Points.p2))
                        
                        textBlock(title: "Carbs",
                                  body: store.meal.carbs.roundToString(Keys.Points.p2))
                        
                        textBlock(title: "Fat",
                                  body: store.meal.fat.roundToString(Keys.Points.p2))
                    }
                }
                .padding(Keys.Padding.px8)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(CardButtonStyle())
        }
    }
    
    private var title: some View {
        Text(store.meal.mealName)
            .font(.title2)
    }
    
    @ViewBuilder
    private func textBlock(title: String, body: String) -> some View {
        VStack {
            Text(title)
                .font(.subheadline)
            Text(body)
                .font(.body)
        }
    }
}
