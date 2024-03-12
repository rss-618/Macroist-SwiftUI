//
//  BorderState.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import SwiftUI

public enum BorderState: Equatable {
    
    case focus
    case unfocus
    case error
    
    public var color: Color {
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
