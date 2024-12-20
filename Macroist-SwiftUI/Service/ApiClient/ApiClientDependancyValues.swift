//
//  DependancyValues.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 12/20/24.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {
    
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
    
}
