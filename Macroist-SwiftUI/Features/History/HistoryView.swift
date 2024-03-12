//
//  HistoryView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/11/24.
//

import ComposableArchitecture
import SwiftUI

public struct HistoryView: View {
    public var body: some View {
        ZStack {
            // Background View
            GenericBackgroundView()
            
            // Content
            VStack {
                Text("History View")
            }
        }
    }
}
