//
//  AddFoodPopoverView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/12/24.
//

import ComposableArchitecture
import SwiftUI

public struct AddFoodPopoverView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var store: StoreOf<AddFoodPopover>
    
    public var body: some View {
            VStack {
                Text("I'm a popover")
                Button {
                    dismiss()
                } label: {
                    Text("dismiss")
                }
            }
    }
    
    public init(store: StoreOf<AddFoodPopover>) {
        self.store = store
    }
}
