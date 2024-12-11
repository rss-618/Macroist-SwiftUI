//
//  IngredientEnryCardView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/15/24.
//

import ComposableArchitecture
import SwiftUI

public struct IngredientEntryCardView: View {

    let removable: Bool
    
    @Perception.Bindable var store: StoreOf<IngredientEntryCard>
    
    public var body: some View {
        WithPerceptionTracking {
            Section {
                InputFieldView(store: store.scope(state: \.name, action: \.name))
                InputFieldView(store: store.scope(state: \.calories, action: \.calories))
                InputFieldView(store: store.scope(state: \.protein, action: \.protein))
                InputFieldView(store: store.scope(state: \.carbs, action: \.carbs))
                InputFieldView(store: store.scope(state: \.fat, action: \.fat))
            } header: {
                HStack {
                    Text("Ingredient")
                        .frame(height: Keys.Height.px20)
                    
                    Spacer()
                    
                    if removable {
                        removeButton
                    }
                }
                .transition(.opacity)
            }
            .listRowSeparator(.hidden)
        }
    }
    
    var removeButton: some View {
        Button {
            store.send(.remove)
        } label: {
            Image(systemName: Keys.SystemIcon.MINUS_CIRCLE_FILL)
                .resizable()
                .frame(width: Keys.Width.px20, height: Keys.Height.px20)
                .tint(Color.red)
        }
    }
}
