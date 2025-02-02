//
//  Login.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import FirebaseAuth
import Foundation

@Reducer
public struct Login: Reducer {
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.runtimeVariables) var runtimeVariables
    
    @ObservableState
    public struct State: Equatable {
        // Child States
        public var emailState: InputField.State = .init(placeholder: "Email")
        public var passwordState: InputField.State = .init(type: .secure, placeholder: "Password")
        public var registration: Registration.State = .init()
        
        // Alert Conditionals and Values
        public var isNetworkError = false
        public var isLoginError = false
        public var isGenericError = false
        public var genericErrorDescription: String = .init()
        
        // Popover Conditional
        public var showRegisterPopover = false
        
        // Logic Values
        public var isLoggingIn = false
    }
    
    public enum Action: Equatable, BindableAction {
        case onAppear
        case loginAttempted
        case loginError(AuthErrorCode)
        case login
        case register
        case email(InputField.Action)
        case password(InputField.Action)
        case binding(BindingAction<State>)
        case registration(Registration.Action)
    }
    
    public var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        //  -- Child Reducers --
        Scope(state: \.emailState, action: \.email) {
            InputField()
        }
        
        Scope(state: \.passwordState, action: \.password) {
            InputField()
        }
        
        Scope(state: \.registration, action: \.registration) {
            Registration()
        }
        // -- End Chld Reducers --
        
        Reduce { state, action in
            switch action {
            case .register:
                state.showRegisterPopover = true
            case .registration(.login):
                state.showRegisterPopover = false
                return .send(.login)
            case .onAppear:
                if let _ = runtimeVariables.getAuthInstance().currentUser {
                    return .send(.login)
                }
            case .loginAttempted:
                // Begin Call
                state.isLoggingIn = true
                // Validate Login
                let email = state.emailState.text
                let password = state.passwordState.text
                
                return .run { send in
                    do {
                        // Attempt login
                        try await apiClient.login(email, password)
                        await send(.login)
                    } catch let e as AuthErrorCode {
                        // Login Error
                        await send.callAsFunction(.loginError(e))
                    } catch {
                        // Client Error
                        await send.callAsFunction(.loginError(.init(.networkError)))
                    }
                }
            case .loginError(let error):
                state.isLoggingIn = false
                switch error.code {
                case .invalidEmail,
                        .wrongPassword:
                    state.isLoginError = true
                case .networkError:
                    state.isNetworkError = true
                default:
                    // Handle the vast array of Google's errors
                    // TODO: Make sure they are not too descriptive to where the user knows too much currently they seem "okay"
                    state.genericErrorDescription = error.localizedDescription
                    state.isGenericError = true
                }
            default:
                break
            }
            return .none
        }
    }
    
}
