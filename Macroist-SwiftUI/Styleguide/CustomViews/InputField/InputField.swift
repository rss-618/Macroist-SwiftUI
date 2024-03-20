//
//  InputField.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct InputField {
    
    public enum Field: Equatable, Hashable {
        case insecure
        case secure
    }
    
    @ObservableState
    public struct State: Equatable {
        public var inputState: InputState
        public var text: String = .init()
        public var placeholder: String = .init()
        public var type: Field
        // Secure only variables
        public var isSecured = true
        
        public init(type: Field = .insecure,
                    inputState: InputState = .unfocus,
                    text: String = .init(),
                    placeholder: String) {
            self.type = type
            self.isSecured = type == .secure
            self.inputState = inputState
            self.text = text
            self.placeholder = placeholder
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case clearInput
        case setFocused(Field)
        case updateInputState(InputState)
    }
    
    public var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .clearInput:
                return .send(.binding(.set(\.text, .init())))
            case .updateInputState(let newInputState):
                state.inputState = newInputState
            default:
                break
            }
            return .none
        }
    }
    
}
