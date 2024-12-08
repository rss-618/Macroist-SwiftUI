//
//  UpdateMealSheetView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 12/8/24.
//

import ComposableArchitecture
import SwiftUI

public struct UpdateMealSheetView: View {
    
    @Perception.Bindable var store: StoreOf<UpdateMealSheet>

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                // TODO: placeholder
                Text(store.meal.mealName)
            }
        }
    }
}
