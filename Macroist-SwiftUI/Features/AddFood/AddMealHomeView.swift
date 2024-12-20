//
//  AddMealHomeView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

public struct AddMealHomeView: View {
    
    @Environment(\.dismiss) var dismiss
    @Perception.Bindable var store: StoreOf<AddMealHome>
    
    public var body: some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVGrid(columns: Keys.Column.flexible2, spacing: Keys.Padding.px16) {
                    // Meal Entry Button
                    AddFoodCardView(text: "Manual Entry", systemImage: Keys.SystemIcon.PENCIL_SLASH) {
                        store.send(.mealEntry)
                    }
                }
                .padding(.horizontal, Keys.Padding.px16)
                .padding(.vertical, Keys.Padding.px32)
            }
            .navigationTitle("Add Meal")
            .toolbar {
                dismissButton
            }
        }
    }
    
    public var dismissButton : some View {
        Button("Cancel") {
            dismiss()
        }
        .padding()
    }
    
    public init(store: StoreOf<AddMealHome>) {
        self.store = store
    }
}
