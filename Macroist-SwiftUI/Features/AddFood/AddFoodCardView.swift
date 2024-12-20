//
//  AddFoodCardView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 12/10/24.
//

import SwiftUI

struct AddFoodCardView: View {
    
    let text: String
    let systemImage: String
    let completion: () -> Void
    
    var body: some View {
        Button {
            completion()
        } label: {
            Label(text, systemImage: systemImage)
        }
        .buttonStyle(CardButtonStyle())
        .frame(idealHeight: Keys.Height.px100)
    }
}
