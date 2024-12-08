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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Keys.Padding.px16) {
                // Manual Entry Button
                Button {
                    store.send(.manualEntry)
                } label: {
                    Label("Manual Entry", systemImage: Keys.SystemIcon.PENCIL_SLASH)
                }
                .buttonStyle(CardButtonStyle())
                .frame(idealHeight: Keys.Height.px100)
            }
            .padding(.horizontal, Keys.Padding.px16)
            .padding(.vertical, Keys.Padding.px32)
        }
        .navigationTitle("Add Meal")
        .toolbar {
            Button("Cancel") {
                dismiss()
            }
            .padding()
        }
    }
    
    public init(store: StoreOf<AddMealHome>) {
        self.store = store
    }
}
