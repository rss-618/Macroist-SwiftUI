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
    @FocusState var focusedField: InputField.Field?
    
    public var body: some View {
        WithPerceptionTracking {
            HStack(spacing: .zero) {
                Group {
                    if store.isSecured {
                        SecureField(text: $store.text) {
                            Text(store.placeholder)
                        }
                        .focused($focusedField, equals: .secure)
                    } else {
                        TextField(text: $store.text) {
                            Text(store.placeholder)
                        }
                        .focused($focusedField, equals: .insecure)
                    }
                }
                .textInputAutocapitalization(.never)
                .font(.callout)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, Keys.Padding.dp2)
                .padding(.horizontal, Keys.Padding.dp12)
                // Clear Input Button
                if store.inputState == .focus && !store.text.isEmpty {
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
                            .padding(.trailing, Keys.Padding.dp12)
                            .padding(.vertical, Keys.Padding.dp13)
                    }
                }
                // Toggle Security Button (secure only)
                if store.type == .secure {
                    Button {
                        // Toggle security value
                        let isSecured = !store.isSecured
                        if focusedField != .none {
                            // Update focus if has focus
                            focusedField = isSecured ? .secure : .insecure
                        }
                        store.send(.binding(.set(\.isSecured, isSecured)))
                    } label: {
                        Image(systemName: store.isSecured
                              ? Keys.SystemIcon.EYE_CICLE
                              : Keys.SystemIcon.EYE_SLASH_CIRCLE)
                            .resizable()
                            .scaledToFit()
                            .font(Font.body.weight(.light))
                            .foregroundStyle(Color.black)
                            .frame(maxHeight: .infinity)
                            .padding(.trailing, Keys.Padding.dp12)
                            .padding(.vertical, Keys.Padding.dp13)
                    }
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: Keys.CornerRadius.dp10)
                    .stroke(store.inputState.borderColor)
            }
            .background {
                RoundedRectangle(cornerRadius: Keys.CornerRadius.dp10)
                    .fill(.white)
            }
            .onChange(of: focusedField) { newVal in
                let state: InputState = (newVal != .none) ? .focus : .unfocus
                store.send(.updateInputState(state))
            }
            .frame(maxWidth: .infinity, idealHeight: Keys.Height.dp52)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    public init(store: StoreOf<InputField>, isFocused: Bool = false) {
        self.store = store
        self.focusedField = isFocused ? (store.isSecured ? .secure : .insecure) : .none
    }
    
}
