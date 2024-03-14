//
//  ApiClient.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay
import FirebaseAuth

// Protocol
struct ApiClient {
    // --- Firebase Calls ---
    // Included within a dependancy for testing and abstraction purposes\
    // -- Auth --
    var createUser: (_ email: String,
                     _ password: String) async throws -> AuthDataResult?
    var login: (_ email: String,
                _ password: String) async throws -> AuthDataResult?
    var logout: () throws ->  Void
    // -- Database --
    // TODO: Implement database things
    // --- End Firebase Calls --
}

// Implementaton
extension ApiClient: DependencyKey {

    static let liveValue: ApiClient = Self(
        createUser: { email, password in
            return try await Auth.auth().createUser(withEmail: email, password: password)
        }, login: { email, password in
            return try await Auth.auth().signIn(withEmail: email, password: password)
        }, logout: {
            return try Auth.auth().signOut()
        }
    )
    
}

// Test Errors
extension ApiClient {
  static let unimplemented = Self(
    createUser: XCTUnimplemented("APIClient.fetchUser"),
    login: XCTUnimplemented("APIClient.login"),
    logout: XCTUnimplemented("APIClient.logout")
  )
}
