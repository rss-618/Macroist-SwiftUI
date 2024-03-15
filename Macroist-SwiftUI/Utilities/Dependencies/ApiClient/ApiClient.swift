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
import FirebaseFirestore

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
    var getMonthMeals: (Date) async throws -> [MacroFood]?
    var addMeal: (_ food: MacroFood) async throws -> Void
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
        }, getMonthMeals: { date in
            let task = Task { () throws -> [MacroFood] in
                let documents = try await Firestore.firestore()
                    .collection(Keys.ID.DB)
                    .document(Auth.auth().currentUser!.uid)
                    .collection(DateUtil.getMonthYearEntryKey(date))
                    .getDocuments()
                    .documents
                
                var meals: [MacroFood] = .init()
                
                for document in documents {
                    meals.append(try document.data(as: MacroFood.self))
                }
                
                return meals
            }
            return try await task.result.get()
        }, addMeal: { food in
            let task = Task { () throws -> Void in
                let data = try JSONEncoder().encode(food)
                guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                        options: .allowFragments) as? [String: Any] else {
                    throw NSError()
                }
                let ref = Firestore.firestore()
                    .collection(Keys.ID.DB)
                    .document(Auth.auth().currentUser!.uid)
                    .collection(DateUtil.getMonthYearEntryKey())
                    .addDocument(data: dictionary)
                return
            }
            return try await task.result.get()
        }
    )
    
}

// Test Errors
extension ApiClient {
  static let unimplemented = Self(
    createUser: XCTUnimplemented("APIClient.fetchUser"),
    login: XCTUnimplemented("APIClient.login"),
    logout: XCTUnimplemented("APIClient.logout"),
    getMonthMeals: XCTUnimplemented("APIClient.getMonthMeals"),
    addMeal: XCTUnimplemented("APIClient.addMeal")
  )
}
