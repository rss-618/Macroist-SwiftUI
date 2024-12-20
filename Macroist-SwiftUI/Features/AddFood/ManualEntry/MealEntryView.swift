//
//  ManualEntryView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

public struct MealEntryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Perception.Bindable var store: StoreOf<MealEntry>
    
    public var body: some View {
        WithPerceptionTracking {
            Section {
                Form {
                    mealNameCard
                        .listRowBackground(Color.gray.opacity(Keys.Opactiy.pct10))

                    ForEach(store.scope(state: \.ingredientCards, action: \.ingredientCards)) { [removable = store.ingredientCards.count > 1 && store.isEditing,
                                                                                                 editable = store.isEditing] store in
                        IngredientEntryCardView(isEditable: editable,
                                                removable: removable,
                                                store: store)
                    }
                    .listRowBackground(Color.gray.opacity(Keys.Opactiy.pct10))
                    
                    if store.isEditing {
                        addIngredientButton
                    }

                    spacer
                }
                .scrollContentBackground(.hidden)
                .formStyle(.grouped)
            }
            .animation(.default, value: store.ingredientCards)
            .navigationTitle(store.variant.title)
            .toolbar {
                switch store.variant {
                case .edit:
                    ToolbarItem(placement: .topBarLeading) {
                        cancelButton
                    }
                    if store.isEditing {
                        ToolbarItem(placement: .topBarTrailing) {
                            updateButton
                        }
                    }
                case .new:
                    ToolbarItem(placement: .topBarTrailing) {
                        saveButton
                    }
                }
            }
            .overlay {
                if store.variant == .edit {
                    editToggleOverlay
                }
            }
        }
    }
    
    var mealNameCard: some View {
        Section {
            if store.isEditing {
                InputFieldView(store: store.scope(state: \.mealNameInput, action: \.mealNameInput))
            } else {
                PsuedoInputView(placeholder: Keys.Text.DASH, text: store.mealNameInput.text)
            }
        } header: {
            Text("Meal Name (Optional)")
        }
    }
    
    var spacer: some View {
        Spacer()
            .listRowBackground(Color.clear)
            .frame(height: Keys.Height.px100) // TOOD: Get Keyboard height calculated here too
    }
    
    @ViewBuilder
    var editToggleOverlay: some View {
        Button {
            store.send(.toggleEditing)
        } label: {
            Image(systemName: store.isEditing ? Keys.SystemIcon.X_CIRCLE : Keys.SystemIcon.PENCIL_CIRCLE)
                .resizable()
                .frame(width: Keys.Width.px48, height: Keys.Height.px48)
                .tint(store.isEditing ? Color.gray : Color.blue)
        }
        .padding(Keys.Padding.px32)
        .align(x: .trailing, y: .bottom)
    }

    
    var saveButton: some View {
        Button("Save") {
            store.send(.savePressed)
        }
        .padding()
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
        .padding()
    }
    
    var updateButton: some View {
        Button("Update") {
            store.send(.updatePressed)
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
    
    public init(store: StoreOf<MealEntry>) {
        self.store = store
    }
    
}
