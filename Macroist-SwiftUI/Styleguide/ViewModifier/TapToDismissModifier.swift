//
//  TapToDismissModifier.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/10/24.
//

import SwiftUI

public struct TapToDismissModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .onTapGesture(coordinateSpace: .global) { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                to: nil,
                                                from: nil,
                                                for: nil)
            }
    }
    
}
