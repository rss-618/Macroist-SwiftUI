//
//  Path.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct Path {
    @ObservableState
    public enum State {
        case home(Home.State)
    }
    
    public enum Action {
        case home(Home.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            Home()
        }
    }
}
