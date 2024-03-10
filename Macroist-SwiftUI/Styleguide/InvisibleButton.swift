//
//  InvisibleButton.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/10/24.
//

import SwiftUI

public struct InvisibleButton: View {

    let action: (() -> Void)?

    public var body: some View {
        Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
    
    public init(action: (() -> Void)? = nil) {
        self.action = action
    }
    
}
