//
//  PsuedoInputView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 12/12/24.
//

import SwiftUI

public struct PsuedoInputView: View {
    
    let placeholder: String
    let text: String
    
    public var body: some View {
        HStack {
            Text(text.isEmpty ? placeholder: text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(text.isEmpty ? Keys.Opactiy.pct33: Keys.Opactiy.pct100)
                .lineLimit(1)
        }
        .frame(height: Keys.Height.px52)
        .padding(.horizontal, Keys.Padding.px12)
        .background {
            background
        }
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: Keys.CornerRadius.px10)
            .fill(.gray)
    }
}
