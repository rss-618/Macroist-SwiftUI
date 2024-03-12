//
//  GenericBackgroundView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import SwiftUI

public struct GenericBackgroundView: View {
    
    public var body: some View {
        Color.gray
            .opacity(Keys.Opactiy.pct33)
            .ignoresSafeArea(.container, edges: .top)
    }
    
}
