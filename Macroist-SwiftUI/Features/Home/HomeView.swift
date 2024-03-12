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
        WithPerceptionTracking {
            TabView(selection: $store.currentTab) {
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: Keys.SystemIcon.PLUS)
                    }
                    .tag(Tab.history)
                
                TodayView(store: store.scope(state: \.todayState, action: \.today))
                    .tabItem {
                        Label("Today", systemImage: Keys.SystemIcon.PLUS)
                    }
                    .tag(Tab.today)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: Keys.SystemIcon.PLUS)
                    }
                    .tag(Tab.settings)
            }
        }
    }
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
}
