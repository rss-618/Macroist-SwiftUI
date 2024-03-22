//
//  InputState.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import SwiftUI

public enum InputState: Equatable {
    case focus
    case unfocus
    case error
    
    public var borderColor: Color {
        switch self {
        case .focus:
            return .blue
        case .unfocus:
            return .gray
        case .error:
            return .red
        }
    }
}
