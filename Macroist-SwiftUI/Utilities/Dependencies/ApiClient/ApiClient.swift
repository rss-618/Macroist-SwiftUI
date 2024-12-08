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
                     _ password: String) async throws -> AuthDataResult
    var login: (_ email: String,
                _ password: String) async throws -> AuthDataResult?
    var logout: () throws ->  Void
    // -- Database --
    var getMonthMeals: (Date) async throws -> [MacroMeal]
    var getDayMeals: (Date) async throws -> [MacroMeal]
    var addMeal: (_ food: MacroMeal) async throws -> Void
    // --- End Firebase Calls --
}

// Implementaton
extension ApiClient: DependencyKey {
    
    private static func createUser(_ email: String, _ password: String) async throws -> AuthDataResult {
        // TODO: Decide if we need a response for register or if a success response code is enough.
        return try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    private static func login(_ email: String, _ password: String) async throws -> AuthDataResult? {
        return try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private static func logout() throws -> Void {
        return try Auth.auth().signOut()
    }
    
    public static func getMonthMeals(_ date: Date) async throws -> [MacroMeal] {
        let task = Task { () throws -> [MacroMeal] in
            guard let uid = Auth.auth().currentUser?.uid else {
                throw AppError.authenticationError
            }
            let documents = try await Firestore.firestore()
                .collection(Keys.ID.DB)
                .document(uid)
                .collection(DateUtil.getMonthYearEntryKey(date))
                .getDocuments()
                .documents
            
            var meals: [MacroMeal] = .init()
            
            for document in documents {
                meals.append(try document.data(as: MacroMeal.self))
            }
            
            return meals
        }
        return try await task.result.get()
    }

    public static func getDayMeals(_ date: Date) async throws -> [MacroMeal] {
        let task = Task { () throws -> [MacroMeal] in
            let calender = Calendar(identifier: .iso8601)
            // TODO: Evaluate if I need a more efficient way over getting day values
            var dayMeals = try await ApiClient.getMonthMeals(date).filter {
                calender.isDate(date, equalTo: $0.timeStamp.dateValue(), toGranularity: .day)
            }
            dayMeals.sort {
                $0.timeStamp.dateValue() > $1.timeStamp.dateValue()
            }
            return dayMeals
        }
        return try await task.result.get()
    }
    
    public static func addMeal(_ food: MacroMeal) async throws -> Void {
        let task = Task { () throws -> Void in
            let data = try JSONEncoder().encode(food)
            guard let uid = Auth.auth().currentUser?.uid else {
                throw AppError.authenticationError
            }
            guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                    options: .allowFragments) as? [String: Any] else {
                throw AppError.technicalError
            }
            let _ = Firestore.firestore()
                .collection(Keys.ID.DB)
                .document(uid)
                .collection(DateUtil.getMonthYearEntryKey())
                .addDocument(data: dictionary)
            return
        }
        return try await task.result.get()
    }

    static let liveValue: ApiClient = Self(
        createUser: {
            try await ApiClient.createUser($0, $1)
        }, login: {
            try await ApiClient.login($0, $1)
        }, logout: {
            try ApiClient.logout()
        }, getMonthMeals: {
            try await ApiClient.getMonthMeals($0)
        }, getDayMeals: {
            try await ApiClient.getDayMeals($0)
        }, addMeal: {
            try await ApiClient.addMeal($0)
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
    getDayMeals: XCTUnimplemented("APIClient.getMonthMeals"),
    addMeal: XCTUnimplemented("APIClient.addMeal")
  )
}
