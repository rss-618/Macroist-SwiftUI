//
//  DependancyValues.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/13/24.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {

    var runtimeVariables: RuntimeVariables {
        get { self[RuntimeVariables.self] }
        set { self[RuntimeVariables.self] = newValue }
    }
    
}
