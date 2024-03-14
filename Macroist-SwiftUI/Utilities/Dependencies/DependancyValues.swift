//
//  DependancyValues.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/13/24.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {
    
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
    
    var runtimeVariables: RuntimeVariables {
        get { self[RuntimeVariables.self] }
        set { self[RuntimeVariables.self] = newValue }
    }
    
}
