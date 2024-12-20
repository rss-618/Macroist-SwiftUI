//
//  Ext_TabView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/23/24.
//

import SwiftUI

extension TabView {
    
    /// Creates a container that encapsulates a TabView with a VStack and adds the app's custom tab bar view on the bttom
    /// - Parameter currentTab: Binding of current tab
    /// - Returns: Opaque View Type
    func customTabBar(_ currentTab: Binding<Tab>) -> some View {
        self.modifier(CustomTabBarModifier(currentTab: currentTab))
    }
}
