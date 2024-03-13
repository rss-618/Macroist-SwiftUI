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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                RoundedRectangle(cornerRadius: Keys.CornerRadius.dp10)
                    .fill(Color.gray.opacity(Keys.Opactiy.pct10))
            }
            .overlay {
                RoundedRectangle(cornerRadius: Keys.CornerRadius.dp10)
                    .stroke(Color.black.opacity(Keys.Opactiy.pct33))
            }
            .foregroundStyle(Color.black.opacity(Keys.Opactiy.pct87))
            .font(.title3)
            .fontWeight(.semibold)
    }
}
