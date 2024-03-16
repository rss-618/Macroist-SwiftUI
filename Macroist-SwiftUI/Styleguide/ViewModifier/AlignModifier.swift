//
//  BottomRightModifier.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import SwiftUI

public struct AlignModifier: ViewModifier {
    
    let x: HorizontalAlignment
    let y: VerticalAlignment
        
    public func body(content: Content) -> some View {
        VStack {
            if y == .bottom || y == .center {
                Spacer()
            }
            HStack {
                if x == .trailing || x == .center {
                    Spacer()
                }
                content
                if x == .leading || x == .center {
                    Spacer()
                }
            }.background {
                Color.clear
            }
            if y == .top || y == .center {
                Spacer()
            }
        }.background {
            Color.clear
        }
    }
    
}
