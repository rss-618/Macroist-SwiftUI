//
//  Ext_View.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/10/24.
//

import SwiftUI

public extension View {
    
    /// Convenience function to be placed on root view to dismiss iOS keyboard
    /// - Returns: Opaque View Type
    func tapToDismissKeyboard() -> some View {
        self.modifier(TapToDismissModifier())
    }
    
    /// Creates a container view for the content that takes up entirety of availble space wtihin parent view
    /// then aligns the content within that view as defined
    ///  - Returns: Opaque View Type
    /// - Parameters:
    ///   - x: Alignment constant along the X-Axis - Default Value is `.center`
    ///   - y: Alignment constant along the Y-Axis - Default Value is `.center`
    func align(x: HorizontalAlignment = .center, y: VerticalAlignment = .center) -> some View {
        self.modifier(AlignModifier(x: x, y: y))
    }
    
    /// Puts width and height to infiinity
    /// - Returns: Modified View
    func maxFrame() -> some View {
        return self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// Creates a container that encapsulates a TabView with a VStack and adds the app's custom tab bar view on the bttom
    /// - Parameter currentTab: Binding of current tab
    /// - Returns: Opaque View Type
    func customTabBar(_ currentTab: Binding<Tab>) -> some View {
        self.modifier(CustomTabBarModifier(currentTab: currentTab))
    }
}
