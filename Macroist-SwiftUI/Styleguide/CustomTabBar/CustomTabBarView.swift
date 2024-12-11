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
            ForEach(Tab.allCases, id: \.hashValue) {
                tabButton(tab: $0)
            }
        }
        .frame(maxWidth: .infinity, idealHeight: Keys.Height.px52)
        .fixedSize(horizontal: false, vertical: true)
        .background {
            Color.gray
                .opacity(Keys.Opactiy.pct10)
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    @ViewBuilder
    private func tabButton(tab: Tab) -> some View {
        Button {
            currentTab = tab
        } label: {
            Label(tab.text, systemImage: tab.iconName)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(currentTab == tab ? Color.blue: Color.gray)
    }
}
