//
//  HistoryView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/11/24.
//

import ComposableArchitecture
import SwiftUI

public struct HistoryView: View {
    
    @State var store: StoreOf<History>
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                // Background View
                GenericBackgroundView()
                
                // Content
                VStack {
                    Text("History View")
                    Text("Meals for \(DateUtil.getMonthYearEntryKey())")
                    if let meals = store.meals {
                        ForEach(meals, id: \.self) { food in
                            Text(food.mealName)
                        }
                    } else {
                        ProgressView()
                    }
                }
                
            }.task {
                store.send(.loadFood)
            }
        }
    }
}
