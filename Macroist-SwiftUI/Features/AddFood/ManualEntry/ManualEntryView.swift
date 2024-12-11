//
//  ManualEntryView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

public struct ManualEntryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Perception.Bindable var store: StoreOf<ManualEntry>
    
    public var body: some View {
        WithPerceptionTracking {
            Section {
                Form {
                    mealNameCard
                        .listRowBackground(Color.gray.opacity(Keys.Opactiy.pct10))

                    ForEach(store.scope(state: \.ingredientCards, action: \.ingredientCards)) { [removable = store.ingredientCards.count > 1] store in
                        IngredientEntryCardView(removable: removable,
                                                store: store)
                    }
                    .listRowBackground(Color.gray.opacity(Keys.Opactiy.pct10))
                    
                    addIngredientButton

                    spacer
                }
                .scrollContentBackground(.hidden)
                .formStyle(.grouped)
            }
            .animation(.default, value: store.ingredientCards)
            .navigationTitle("Manual Entry")
            .toolbar {
                saveButton
            }
        }
    }
    
    var mealNameCard: some View {
        Section {
            InputFieldView(store: store.scope(state: \.mealNameInput, action: \.mealNameInput))
        } header: {
            Text("Meal Name (Optional)")
        }
    }
    
    var spacer: some View {
        Spacer()
            .listRowBackground(Color.clear)
            .frame(height: Keys.Height.px100) // TOOD: Get Keyboard height calculated here too
    }
    
    var saveButton: some View {
        Button("Save") {
            store.send(.savePressed)
        }
        .padding()
    }
    
    var addIngredientButton: some View {
        HStack {
            Spacer()
            Button {
                store.send(.addIngredient)
            } label: {
                Text("Add Ingredient")
            }
            Spacer()
        }
        .buttonStyle(BorderedButtonStyle())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    public init(store: StoreOf<ManualEntry>) {
        self.store = store
    }
    
}
