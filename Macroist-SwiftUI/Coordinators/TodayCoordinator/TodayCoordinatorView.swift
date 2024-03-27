//
//  TodayCoordinatorView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/22/24.
//

import ComposableArchitecture
import SwiftUI

public struct TodayCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<TodayCoordinator>

    public var body: some View {
        WithPerceptionTracking {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path)
            ) {
                // Root view of the navigation stack
                TodayView(store: store.scope(state: \.today, action: \.today))
            } destination: { store in
                // TODO: update this to be any following path view
                //                    switch store.state {
                //                    case .manualEntry:
                //                        ManualEntryView(store: store.scope(state: \.manualEntry, action: \.manualEntry))
                //                    }
            }
        }
    }
}
