//
//  FoodPopoverPath.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation

extension FoodSheetCoordinator {
    
    @Reducer
    public struct Path {
        
        @ObservableState
        public enum State: Equatable {
            case manualEntry(ManualEntry.State)
        }
        
        public enum Action {
            case manualEntry(ManualEntry.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.manualEntry, action: \.manualEntry) {
                ManualEntry()
            }
        }
    }
    
}
