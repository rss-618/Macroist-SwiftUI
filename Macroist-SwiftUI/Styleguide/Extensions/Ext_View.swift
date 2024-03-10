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
    
}
