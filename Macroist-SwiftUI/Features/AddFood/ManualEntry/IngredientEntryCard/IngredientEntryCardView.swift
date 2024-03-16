//
//  IngredientEnryCardView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/15/24.
//

import ComposableArchitecture
import SwiftUI

public struct IngredientEntryCardView: View {

    @Perception.Bindable var store: StoreOf<IngredientEntryCard>
    
    public var body: some View {
        WithPerceptionTracking {
            Section(header: Text("Ingredient")) {
                InputFieldView(store: store.scope(state: \.name, action: \.name))
                InputFieldView(store: store.scope(state: \.calories, action: \.calories))
                InputFieldView(store: store.scope(state: \.protein, action: \.protein))
                InputFieldView(store: store.scope(state: \.carbs, action: \.carbs))
                InputFieldView(store: store.scope(state: \.fat, action: \.fat))
            }
            .listRowBackground(Color.gray.opacity(Keys.Opactiy.pct10))
            .listRowSeparator(.hidden)

        }
    }
}
