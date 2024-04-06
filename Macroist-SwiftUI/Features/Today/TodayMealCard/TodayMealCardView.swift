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
                    Text(store.meal.mealName)
                        .font(.title2)
                    HStack {
                        VStack {
                            Text("Calories")
                                .font(.subheadline)
                            Text(store.meal.calories.roundToString(Keys.Points.p2))
                                .font(.body)
                        }
                        
                        VStack {
                            Text("Protein")
                                .font(.subheadline)
                            Text(store.meal.protein.roundToString(Keys.Points.p2))
                                .font(.body)
                        }
                        
                        VStack {
                            Text("Carbs")
                                .font(.subheadline)
                            Text(store.meal.carbs.roundToString(Keys.Points.p2))
                                .font(.body)
                        }
                        
                        VStack {
                            Text("Fat")
                                .font(.subheadline)
                            Text(store.meal.fat.roundToString(Keys.Points.p2))
                                .font(.body)
                        }
                    }
                }
                .padding(Keys.Padding.dp8)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(CardButtonStyle())
        }
    }
}
