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
                                .foregroundStyle(Color.black.opacity(Keys.Opactiy.pct33))
                        }
                        .focused($focusedField, equals: .secure)
                    } else {
                        TextField(text: $store.text) {
                            Text(store.placeholder)
                                .foregroundStyle(Color.black.opacity(Keys.Opactiy.pct33))
                        }
                        .focused($focusedField, equals: .insecure)
                    }
                }
                .textInputAutocapitalization(.never)
                .font(.callout)
                .foregroundStyle(Color.black.opacity(Keys.Opactiy.pct90))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, Keys.Padding.px2)
                .padding(.horizontal, Keys.Padding.px12)
                // Clear Input Button
                if store.inputState == .focus && !store.text.isEmpty {
                    // Clear input button
                    clearInputButton
                }
                // Toggle Security Button (secure only)
                if store.type == .secure {
                    securityToggle
                }
            }
            .background {
                background
            }
            .onAppear {
                // TODO: Figure out better way to unfocus onDisappear, changed it to onAppear because we had issues with store.send firing when the reducer is also removed
                // This way may cause complications with autofocus type stuff need to double check
                store.send(.updateInputState(.unfocus))
            }
            .onChange(of: focusedField) { newVal in
                store.send(.updateInputState((newVal != .none) ? .focus : .unfocus))
            }
            .frame(maxWidth: .infinity, idealHeight: Keys.Height.px52)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: Keys.CornerRadius.px10)
            .fill(.white)
            .overlay {
                RoundedRectangle(cornerRadius: Keys.CornerRadius.px10)
                    .stroke(store.inputState.borderColor)
            }
    }
    
    var clearInputButton: some View {
        Button {
            store.send(.clearInput)
        } label: {
            Image(systemName: Keys.SystemIcon.X_CIRCLE)
                .resizable()
                .scaledToFit()
                .font(Font.body.weight(.light))
                .foregroundStyle(Color.black)
                .frame(maxHeight: .infinity)
                .padding(.trailing, Keys.Padding.px12)
                .padding(.vertical, Keys.Padding.px13)
        }
    }
    
    var securityToggle: some View {
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
                .padding(.trailing, Keys.Padding.px12)
                .padding(.vertical, Keys.Padding.px13)
        }
    }
    
    public init(store: StoreOf<InputField>, isFocused: Bool = false) {
        self.store = store
        self.focusedField = isFocused ? (store.isSecured ? .secure : .insecure) : .none
    }
    
}
