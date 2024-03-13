//
//  AddFoodHomeView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

public struct AddFoodHomeView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var store: StoreOf<AddFoodHome>
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Keys.Padding.dp16) {
                // Manual Entry Button
                Button {
                    store.send(.manualEntry)
                } label: {
                    Label("Manual Entry", systemImage: Keys.SystemIcon.PENCIL_SLASH)
                }
                .buttonStyle(CardButtonStyle())
                .frame(idealHeight: Keys.Height.dp100)
            }
            .padding(.horizontal, Keys.Padding.dp16)
            .padding(.vertical, Keys.Padding.dp32)
        }
        .navigationTitle("Add Food")
        .toolbar {
            Button("Cancel") {
                dismiss()
            }
            .padding()
        }
    }
    
    public init(store: StoreOf<AddFoodHome>) {
        self.store = store
    }
}
