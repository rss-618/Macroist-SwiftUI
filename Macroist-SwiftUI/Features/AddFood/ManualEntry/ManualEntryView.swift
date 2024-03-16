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
            ZStack {
                Form {
                    Section(header: Text("Meal Name (Optional)")) {
                        InputFieldView(store: store.scope(state: \.mealNameInput, action: \.mealNameInput))
                    }            
                    .listRowBackground(Color.gray.opacity(Keys.Opactiy.pct10))

                    ForEach(store.scope(state: \.ingredientCards, action: \.ingredientCards)) { store in
                        IngredientEntryCardView(store: store)
                    }
                    
                    Spacer()
                        .frame(height: Keys.Height.dp100) // TOOD: Get Keyboard height calculated here too
                }
                .scrollContentBackground(.hidden)
                .formStyle(.grouped)
                .listRowBackground(Color.blue)
                
                Button {
                    store.send(.addIngredient)
                } label: {
                    Text("Add Ingredient")
                }
                .padding(Keys.Padding.dp32)
                .buttonStyle(BorderedButtonStyle())
                .align(x: .center, y: .bottom)
            }
            .animation(.default, value: store.ingredientCards)
        }
        .navigationTitle("Manual Entry")
        .toolbar {
            Button("Save") {
                store.send(.savePressed)
            }
            .padding()
        }
    }
    
    public init(store: StoreOf<ManualEntry>) {
        self.store = store
    }
    
}
