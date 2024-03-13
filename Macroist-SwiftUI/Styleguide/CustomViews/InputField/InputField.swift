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
    
    @ObservableState
    public struct State: Equatable {
        
        public var borderState: BorderState
        public var text: String = .init()
        public var placeholder: String = .init()
        
        public init(borderState: BorderState = .unfocus,
                    text: String = .init(),
                    placeholder: String) {
            self.borderState = borderState
            self.text = text
            self.placeholder = placeholder
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case clearInput
        case updateBorderState(BorderState)
    }
    
    public var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .clearInput:
                return .send(.binding(.set(\.text, .init())))
            case .updateBorderState(let newBorderState):
                state.borderState = newBorderState
            default:
                break
            }
            return .none
        }
    }
    
}
