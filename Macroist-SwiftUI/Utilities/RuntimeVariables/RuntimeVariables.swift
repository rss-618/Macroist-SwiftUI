//
//  RuntimeVariables.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/13/24.
//

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay
import FirebaseAuth

// Protocol
struct RuntimeVariables {
    var getAuthInstance: () -> Auth
}

// Implementaton
extension RuntimeVariables: DependencyKey {
        
    static let liveValue: RuntimeVariables = Self(
        getAuthInstance: {
            return Auth.auth()
        }
    )
    
}

// Test Errors
extension RuntimeVariables {
  static let unimplemented = Self(
    getAuthInstance: XCTUnimplemented("RuntimeVariables.getAuthInstance")
  )
}
