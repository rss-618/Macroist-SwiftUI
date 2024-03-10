//
//  Home.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct Home {
    
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        case logout
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                break
            }
            return .none
        }
    }
}
