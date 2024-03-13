//
//  ManualEntryView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

public struct ManualEntryView: View {
    
    @State var store: StoreOf<ManualEntry>
    
    public var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("Manual Entry")
            }
            .navigationTitle("Manual Entry")
        }
    }
    
    public init(store: StoreOf<ManualEntry>) {
        self.store = store
    }
    
}
