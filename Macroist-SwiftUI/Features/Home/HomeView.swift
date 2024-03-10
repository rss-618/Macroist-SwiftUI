//
//  HomeView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import SwiftUI

public struct HomeView: View {
    
    @State var store: StoreOf<Home>
    
    public var body: some View {
        // TODO: Skeleton out a ui and give all interactable things a destination
        VStack {
            Text("Home")
            Button {
                store.send(.logout)
            } label: {
                Text("Log Out")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
}
