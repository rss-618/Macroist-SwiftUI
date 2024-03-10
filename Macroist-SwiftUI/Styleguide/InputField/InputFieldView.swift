//
//  InputFieldView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import SwiftUI

public struct InputFieldView: View {
    
    @State var store: StoreOf<InputField>
    @FocusState var isFocused: Bool
    
    public var body: some View {
        WithPerceptionTracking {
            HStack(spacing: .zero) {
                TextField(text: $store.text) {
                    Text(store.placeholder)
                }.focused($isFocused)
                    .textInputAutocapitalization(.never)
                    .font(.callout)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, Keys.Padding.dp2)
                    .padding(.horizontal, Keys.Padding.dp16)
            }
            .overlay {
                RoundedRectangle(cornerRadius: Keys.CornerRadius.dp10)
                    .stroke(store.borderState.color)
            }
            .background {
                RoundedRectangle(cornerRadius: Keys.CornerRadius.dp10)
                    .fill(.white)
            }
            .onChange(of: isFocused) { newVal in
                store.send(.updateBorderState(newVal ? .focus : .unfocus))
            }
            .frame(maxWidth: .infinity, idealHeight: Keys.Height.dp52)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    public init(store: StoreOf<InputField>, isFocused: Bool = false) {
        self.store = store
        self.isFocused = isFocused
    }
    
}
