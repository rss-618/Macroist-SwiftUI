//
//  CardButtonStyle.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/13/24.
//

import SwiftUI

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .maxFrame()
            .background {
                RoundedRectangle(cornerRadius: Keys.CornerRadius.px10)
                    .fill(Color.gray.opacity(Keys.Opactiy.pct10))
                    .overlay {
                        RoundedRectangle(cornerRadius: Keys.CornerRadius.px10)
                            .stroke(Color.black.opacity(Keys.Opactiy.pct33))
                    }
            }
            .foregroundStyle(Color.gray)
            .font(.title3)
            .fontWeight(.semibold)
            .scaleEffect(configuration.isPressed ? Keys.Scale.pct95 : Keys.Scale.pct100)
            .opacity(configuration.isPressed ? Keys.Opactiy.pct33 : Keys.Opactiy.pct100)
            .animation(.default, value: configuration.isPressed)
    }
}
