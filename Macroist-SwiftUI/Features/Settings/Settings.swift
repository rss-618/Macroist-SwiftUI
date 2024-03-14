//
//  Settings.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/13/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct Settings {
   
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        case logout // Parent Call
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
