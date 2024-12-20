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
    
    @Perception.Bindable var store: StoreOf<Home>
    
    public var body: some View {
        WithPerceptionTracking {
            Section {
                switch(store.currentTab) {
                case .history:
                    HistoryView(store: store.scope(state: \.historyState, action: \.history))
                        .tag(Tab.history)
                case .today:
                    TodayView(store: store.scope(state: \.todayState, action: \.today))
                        .tag(Tab.today)
                case .settings:
                    SettingsView(store: store.scope(state: \.settingsState, action: \.settings))
                        .tag(Tab.settings)
                }
            }
            .customTabBar($store.currentTab)
        }
    }
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
}
