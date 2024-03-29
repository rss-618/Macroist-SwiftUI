//
//  LoginView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import SwiftUI
import FirebaseCore
import FirebaseFirestore

public struct LoginView: View {
    
    @Perception.Bindable var store: StoreOf<Login>
    @FocusState var currentInput: Input?
    
    enum Input: Hashable {
        case email
        case password
    }
    
    public var body: some View {
        WithPerceptionTracking {
            // Content View
            VStack(spacing: .zero) {
                // Title Header
                Text("Macroist")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding(Keys.Padding.dp16)
                    .foregroundStyle(Color.white)
                
                // Input Fields
                VStack(spacing: Keys.Padding.dp8) {
                    // Username Field
                    InputFieldView(store: store.scope(state: \.emailState, action: \.email))
                        .focused($currentInput, equals: .email)
                        .onSubmit {
                            currentInput = .password
                        }
                    
                    // Password Field
                    InputFieldView(store: store.scope(state: \.passwordState, action: \.password))
                        .focused($currentInput, equals: .password)
                        .onSubmit {
                            currentInput = .none
                            store.send(.loginAttempted)
                        }
                }
                .padding(.horizontal, Keys.Padding.dp16)
                
                // Login Button
                Button {
                    currentInput = .none
                    store.send(.loginAttempted)
                } label: {
                    Text("Login")
                        .font(.title3)
                        .frame(width: Keys.Width.dp100, height: Keys.Height.dp44)
                }
                .disabled(store.isLoggingIn)
                .overlay {
                    if store.isLoggingIn {
                        ProgressView()
                    }
                }
                .buttonStyle(BorderedButtonStyle())
                .foregroundStyle(Color.white)
                .padding(.vertical, Keys.Padding.dp16)
                
                Button {
                    store.send(.register)
                } label: {
                    Text("Create Account")
                }

                Spacer()
            }
            .padding(.top, Keys.Padding.dp100)
            .maxFrame()
            .background {
                Color.blue.opacity(Keys.Opactiy.pct33).ignoresSafeArea(.all)
            }
            .tapToDismissKeyboard()
            .alert("Sorry!", isPresented: $store.isLoginError) {
                // OK is the default if left empty
            } message: {
                Text("An error has occurred. Please try again.")
            }
            .alert("Uh Oh!", isPresented: $store.isLoginError) {
                // OK is the default if left empty
            } message: {
                Text("Your email or password is incorrect, Please try again.")
            }
            .alert("Uh Oh!", isPresented: $store.isGenericError) {
                // OK is the default if left empty
            } message: {
                WithPerceptionTracking {
                    Text(store.genericErrorDescription)
                }
            }
            .popover(isPresented: $store.showRegisterPopover) {
                RegistrationView(store: store.scope(state: \.registration, action: \.registration))
            }
            .task {
                // TODO: Make an additional view other than login for this check logic to avoid flashing view
                await store.send(.onAppear).finish()
            }
        }
    }
    
    public init(store: StoreOf<Login>) {
        self.store = store
    }
}
