//
//  TodayView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/11/24.
//

import ComposableArchitecture
import SwiftUI

public struct TodayView: View {
    
    @State var store: StoreOf<Today>
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                // Background View
                GenericBackgroundView()
                
                // Content
                VStack {
                    Text("Today View")
                }
                
                // Floating Icon
                FloatingButton(iconName: Keys.SystemIcon.PLUS) {
                    store.send(.binding(.set(\.isAddFoodShowing, true)))
                }
                
                .padding(Keys.Padding.dp32)
                .align(x: .trailing, y: .bottom)
            }
            .popover(isPresented: $store.isAddFoodShowing) {
                AddFoodPopoverView(store: store.scope(state: \.addFoodState, action: \.addFood))
            }
        }
    }
    
    public init(store: StoreOf<Today>) {
        self.store = store
    }
    
}
