//
//  FloatingButton.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/11/24.
//

import SwiftUI

public struct FloatingButton: View {
    
    let iconName: String
    let action: () -> Void
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: iconName)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(Keys.Padding.dp12)
                .foregroundStyle(.white)
        }.background {
            Circle()
                .fill(.blue)
        }
        .frame(width: Keys.Width.dp52, height: Keys.Height.dp52)
        .shadow(radius: Keys.CornerRadius.dp10, x: Keys.Offset.dp2, y: Keys.Offset.dp2)
    }
    
    public init(iconName: String, action: @escaping () -> Void) {
        self.iconName = iconName
        self.action = action
    }
}


