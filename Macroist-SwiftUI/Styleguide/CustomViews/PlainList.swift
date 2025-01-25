//
//  PlainList.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 12/10/24.
//

import ComposableArchitecture
import SwiftUI

public struct PlainList<Content: View>: View {
    
    let spacing: CGFloat
    let padding: EdgeInsets

    let content : Content
    
    public init(spacing: CGFloat = .zero,
                horizontalPadding: CGFloat = .zero,
                @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.padding = .init(top: .zero,
                             leading: horizontalPadding,
                             bottom: .zero,
                             trailing: horizontalPadding)
        self.content = content()
    }
    
    public var body: some View {
        List {
            WithPerceptionTracking {
                Group {
                    content
                }
                .listRowSeparator(.hidden)
                .listRowInsets(padding)
            }
        }
        .listRowSpacing(spacing)
        .listStyle(PlainListStyle())
    }
}
