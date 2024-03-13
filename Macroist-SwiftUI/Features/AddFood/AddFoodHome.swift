//
//  AddFoodPopover.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct AddFoodHome {
    
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        case manualEntry // Parent Call
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
