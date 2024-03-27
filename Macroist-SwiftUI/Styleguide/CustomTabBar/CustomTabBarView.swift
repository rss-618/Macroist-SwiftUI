//
//  CustomTabBarView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/23/24.
//

import SwiftUI

public struct CustomTabBarView: View {
    @Binding var currentTab: Tab
    
    public var body: some View {
        HStack {
            Button {
                currentTab = .history
            } label: {
                Label("History", systemImage: Keys.SystemIcon.CLOCK)
            }
            .maxFrame()
            .foregroundStyle(currentTab == .history ? Color.blue: Color.black)
            
            Button {
                currentTab = .today
            } label: {
                Label("Today", systemImage: Keys.SystemIcon.CALENDAR_CIRCLE)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(currentTab == .today ? Color.blue: Color.black)
            
            Button {
                currentTab = .settings
            } label: {
                Label("Settings", systemImage: Keys.SystemIcon.GEARSHAPE)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(currentTab == .settings ? Color.blue: Color.black)
        }
        .frame(maxWidth: .infinity, idealHeight: Keys.Height.dp52)
        .fixedSize(horizontal: false, vertical: true)
        .background {
            Color.gray
                .opacity(Keys.Opactiy.pct10)
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
