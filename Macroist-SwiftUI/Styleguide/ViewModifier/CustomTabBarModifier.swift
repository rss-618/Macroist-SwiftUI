//
//  CustomTabBarModifier.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/23/24.
//

import SwiftUI

public struct CustomTabBarModifier: ViewModifier {
    
    @Binding var currentTab: Tab
    
    public func body(content: Content) -> some View {
        VStack(spacing: .zero) {
            content
                .maxFrame()
            
            CustomTabBarView(currentTab: $currentTab)
        }
    }
    
}
