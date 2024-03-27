//
//  RegistrationView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/27/24.
//

import ComposableArchitecture
import SwiftUI

public struct RegistrationView: View {
    
    @Perception.Bindable var store: StoreOf<Registration>
    @FocusState var currentInput: Input?
    @Environment(\.dismiss) var dismiss
    
    enum Input: Hashable {
        case email
        case password
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: .zero) {
                HStack {
                    Spacer()
                    Button("Dismiss") {
                        dismiss()
                    }
                }
                
                Text("Create your Account")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.vertical, Keys.Padding.dp12)
                Text("Enter your email and password in order to create your Macroist account.")
                    .font(.headline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Keys.Padding.dp12)
                
                // Input Fields
                VStack(spacing: Keys.Padding.dp8) {
                    // Username Field
                    InputFieldView(store: store.scope(state: \.email, action: \.email))
                        .focused($currentInput, equals: .email)
                        .onSubmit {
                            currentInput = .password
                        }
                    
                    // Password Field
                    InputFieldView(store: store.scope(state: \.password, action: \.password))
                        .focused($currentInput, equals: .password)
                        .onSubmit {
                            currentInput = .none
                            store.send(.registerAttempted)
                        }
                }
                .padding(.horizontal, Keys.Padding.dp16)
                
                // Login Button
                Button {
                    currentInput = .none
                    store.send(.registerAttempted)
                } label: {
                    Text("Register")
                        .font(.title3)
                        .frame(width: Keys.Width.dp100, height: Keys.Height.dp44)
                }
                .disabled(store.isRegistering)
                .overlay {
                    if store.isRegistering {
                        ProgressView()
                    }
                }
                .buttonStyle(BorderedButtonStyle())
                .foregroundStyle(store.isRegistering ? Color.gray: Color.black)
                .padding(.vertical, Keys.Padding.dp16)
                
                Spacer()
            }
            .background(Color.white)
            .padding(Keys.Padding.dp24)
            .maxFrame()
            .tapToDismissKeyboard()
            .alert("Uh Oh!", isPresented: $store.isGenericError) {
                // OK is the default if left empty
            } message: {
                WithPerceptionTracking {
                    Text(store.genericErrorDescription)
                }
            }
            .alert("Success!", isPresented: $store.showSuccess) {
                // OK is the default if left empty
                Button("OK") {
                    store.send(.login)
                }
            } message: {
                Text("Your account has been created.")
            }
        }
    }
}
