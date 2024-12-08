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
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeIn, value: currentTab)
                .transition(.slide)
            
            CustomTabBarView(currentTab: $currentTab)
        }
    }
    
}
