//
//  TodayMealCardView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 4/5/24.
//

import ComposableArchitecture
import SwiftUI

public struct TodayMealCardView: View {
    
    let meal: MacroMeal
    let completion: () -> Void

    public var body: some View {
        Button {
            completion()
        } label: {
            VStack {
                title
                
                HStack {
                    textBlock(title: "Calories",
                              body: meal.calories.roundToString(Keys.Points.p2))
                    
                    textBlock(title: "Protein",
                              body: meal.protein.roundToString(Keys.Points.p2))
                    
                    textBlock(title: "Carbs",
                              body: meal.carbs.roundToString(Keys.Points.p2))
                    
                    textBlock(title: "Fat",
                              body: meal.fat.roundToString(Keys.Points.p2))
                }
            }
            .padding(Keys.Padding.px8)
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(CardButtonStyle())
        
    }
    
    private var title: some View {
        Text(meal.mealName)
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
