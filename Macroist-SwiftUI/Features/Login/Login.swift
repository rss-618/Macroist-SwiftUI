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
        public var passwordState: InputField.State = .init(placeholder: "Password")
        
        // Alert Conditionals and Values
        public var isNetworkError = false
        public var isLoginError = false
        public var isGenericError = false
        public var genericErrorDescription: String = .init()
        
        // Logic Values
        public var isLoggingIn = false
    }
    
    public enum Action: Equatable, BindableAction {
        case onAppear
        case loginAttempted
        case loginAttemptResponse(AuthDataResult?)
        case loginError(AuthErrorCode)
        case login
        case email(InputField.Action)
        case password(InputField.Action)
        case binding(BindingAction<State>)
    }
    
    public var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        //  -- Child Reducers --
        Scope(state: \.emailState, action: /Action.email) {
            InputField()
        }
        
        Scope(state: \.passwordState, action: /Action.password) {
            InputField()
        }
        // -- End Chld Reducers --
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                if let user = runtimeVariables.getAuthInstance().currentUser {
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
                        try await send.callAsFunction(.loginAttemptResponse(apiClient.login(email, password)))
                    } catch let e as AuthErrorCode {
                        // Login Error
                        await send.callAsFunction(.loginError(e))
                    } catch {
                        // Client Error
                        await send.callAsFunction(.loginError(.init(.networkError)))
                    }
                }
            case .loginAttemptResponse(let response):
                state.isLoggingIn = false
                if response != nil {
                    return .send(.login)
                } else {
                    return .send(.loginError(.init(.networkError)))
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
