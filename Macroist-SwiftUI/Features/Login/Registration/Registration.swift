//
//  Registration.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/27/24.
//

import FirebaseAuth
import ComposableArchitecture
import SwiftUI

@Reducer
public struct Registration {
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    public struct State: Equatable {
        var email: InputField.State = .init(placeholder: "Email")
        var password: InputField.State = .init(placeholder: "Password")
        
        var isGenericError = false
        var showSuccess = false
        var genericErrorDescription: String = .init()
        var isRegistering = false
    }
    
    public enum Action: Equatable, BindableAction {
        case email(InputField.Action)
        case password(InputField.Action)
        case binding(BindingAction<State>)
        case registerAttempted
        case registerSuccess
        case error(AuthErrorCode)
        case login
    }
    
    public var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Scope(state: \.email, action: \.email) {
            InputField()
        }
        
        Scope(state: \.password, action: \.password) {
            InputField()
        }
        
        Reduce { state, action in
            switch action {
            case .registerAttempted:
                state.isRegistering = true
                return .run { [state] send in
                    do {
                        try await apiClient.createUser(state.email.text.trimWhiteSpaceAndNewline(),
                                                       state.password.text.trimWhiteSpaceAndNewline())
                        await send(.registerSuccess)
                    } catch let e as AuthErrorCode {
                        // Server Response Error
                        await send(.error(e))
                    } catch {
                        // Client error
                        await send.callAsFunction(.error(.init(.networkError)))
                    }
                }
            case .registerSuccess:
                state.showSuccess = true
            case .error(let error):
                state.isRegistering = false
                state.genericErrorDescription = error.localizedDescription
                state.isGenericError = true
            default:
                break
            }
            return .none
        }
    }
}
