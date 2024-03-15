//
//  HomeView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import SwiftUI
import FirebaseCore
import FirebaseFirestore

public struct HomeView: View {
    
    @State var store: StoreOf<Home>
    
    public var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.currentTab) {
                HistoryView(store: store.scope(state: \.historyState, action: \.history))
                    .tabItem {
                        Label("History", systemImage: Keys.SystemIcon.CLOCK)
                    }
                    .tag(Tab.history)
                
                TodayView(store: store.scope(state: \.todayState, action: \.today))
                    .tabItem {
                        Label("Today", systemImage: Keys.SystemIcon.CALENDAR_CIRCLE)
                    }
                    .tag(Tab.today)
                
                SettingsView(store: store.scope(state: \.settingsState, action: \.settings))
                    .tabItem {
                        Label("Settings", systemImage: Keys.SystemIcon.GEARSHAPE)
                    }
                    .tag(Tab.settings)
            }
        }
    }
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
}
