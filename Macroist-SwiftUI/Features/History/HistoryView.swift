//
//  HistoryView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/11/24.
//

import ComposableArchitecture
import SwiftUI

public struct HistoryView: View {
    
    @Perception.Bindable var store: StoreOf<History>
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                // Content
                VStack {
                    Text("History View")
                    Text("Meals for \(DateEntryKey().value)")
                    if let meals = store.meals {
                        // TOOD: needs real UI
                        ForEach(meals, id: \.self) { food in
                            Text(food.mealName)
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
            .navigationTitle("History")
            .task {
                print("loading history")
                store.send(.loadFood)
            }
        }
    }
}
