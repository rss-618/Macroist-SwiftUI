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

struct RuntimeVariables: DependencyKey {
    
    static let liveValue: RuntimeVariables = Self(
        getAuthInstance: {
            return Auth.auth()
        }
    )
    
    static let testValue: RuntimeVariables = Self(
        getAuthInstance: unimplemented("RuntimeVariables.getAuthInstance", placeholder: Auth.auth())
    )
    
    var getAuthInstance: () -> Auth
    
}
