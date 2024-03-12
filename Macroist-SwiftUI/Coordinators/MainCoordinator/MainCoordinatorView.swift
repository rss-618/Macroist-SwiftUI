//
//  MainCoordinatorView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import SwiftUI

struct MainCoordinatorView: View {
    
  @State var store: StoreOf<MainCoordinator>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path)
            ) {
                // Root view of the navigation stack
                HomeView(store: store.scope(state: \.home, action: \.home))
            } destination: { store in
                // A view for each case of the Path.State enum
            }
        }
    }
}
