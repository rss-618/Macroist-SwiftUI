//
//  InputFieldView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import SwiftUI

public struct InputFieldView: View {
    
    @Perception.Bindable var store: StoreOf<InputField>
    @FocusState var isFocused: Bool
    
    public var body: some View {
        WithPerceptionTracking {
            HStack(spacing: .zero) {
                // TODO: Create a secure textfield
                TextField(text: $store.text) {
                    Text(store.placeholder)
                }
                .focused($isFocused)
                .textInputAutocapitalization(.never)
                .font(.callout)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, Keys.Padding.dp2)
                .padding(.leading, Keys.Padding.dp16)
                // Clear Input Button
                if store.borderState == .focus && !store.text.isEmpty {
                    // Clear input button
                    Button {
                        store.send(.clearInput)
                    } label: {
                        Image(systemName: Keys.SystemIcon.X_CIRCLE)
                            .resizable()
                            .scaledToFit()
                            .font(Font.body.weight(.light))
                            .foregroundStyle(Color.black)
                            .frame(maxHeight: .infinity)
                            .padding(.horizontal, Keys.Padding.dp12)
                            .padding(.vertical, Keys.Padding.dp16)
                    }
                }
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
