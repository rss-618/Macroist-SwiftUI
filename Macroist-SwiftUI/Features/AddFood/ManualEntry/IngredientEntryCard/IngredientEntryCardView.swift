//
//  IngredientEnryCardView.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/15/24.
//

import ComposableArchitecture
import SwiftUI

public struct IngredientEntryCardView: View {

    let isEditable: Bool
    let removable: Bool
    
    enum Field {
        case name
        case calories
        case protein
        case carbs
        case fat
        
        var isNumber: Bool {
            self != .name
        }
        
        var title: String {
            switch self {
            case .name:
                "Name"
            case .calories:
                "Calories"
            case .protein:
                "Protein"
            case .carbs:
                "Carbs"
            case .fat:
                "Fat"
            }
        }
        
        var emptyPlaceholder: String {
            switch self {
            case .name:
                Keys.Text.DASH
            default:
                Keys.Text.ZERO
            }
        }
    }
    
    @Perception.Bindable var store: StoreOf<IngredientEntryCard>
    
    public var body: some View {
        WithPerceptionTracking {
            Section {
                field(.name, store: store.scope(state: \.name, action: \.name))
                field(.calories, store: store.scope(state: \.calories, action: \.calories))
                field(.protein, store: store.scope(state: \.protein, action: \.protein))
                field(.carbs, store: store.scope(state: \.carbs, action: \.carbs))
                field(.fat, store: store.scope(state: \.fat, action: \.fat))
            } header: {
                HStack {
                    ingredientTitle
                    
                    Spacer()
                    
                    if removable {
                        removeButton
                    }
                }
                .transition(.opacity)
            }
            .listRowSeparator(.hidden)
        }
    }
    
    @ViewBuilder
    func field(_ field: Field, store: StoreOf<InputField>) -> some View {
        VStack {
            Text(field.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnote)
            
            if isEditable {
                InputFieldView(store: store)
            } else {
                PsuedoInputView(placeholder: field.emptyPlaceholder, text: store.text)
            }
        }
    }
    
    var ingredientTitle: some View {
        Text("Ingredient")
            .frame(height: Keys.Height.px20)
    }
    
    var removeButton: some View {
        Button {
            store.send(.remove)
        } label: {
            Image(systemName: Keys.SystemIcon.MINUS_CIRCLE_FILL)
                .resizable()
                .frame(width: Keys.Width.px20, height: Keys.Height.px20)
                .tint(Color.red)
        }
    }
}
