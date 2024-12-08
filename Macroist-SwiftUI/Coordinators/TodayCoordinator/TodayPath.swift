//
//  TodayPath.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/22/24.
//

import ComposableArchitecture
import Foundation

extension TodayCoordinator {
    
    @Reducer
    public struct Path {
        
        @ObservableState
        public struct State: Equatable {
        }
        
        public enum Action {
        }
        
        public var body: some ReducerOf<Self> {
            EmptyReducer()
        }
    }
    
}
