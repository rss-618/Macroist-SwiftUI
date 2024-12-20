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
    var deleteMeal: (DateEntryKey, UUID) async throws -> Void
    var deleteTodaysMeal: (UUID) async throws -> Void
    var getMonthMeals: (DateEntryKey) async throws -> [MacroMeal]
    var getDayMeals: (DateEntryKey) async throws -> [MacroMeal]
    var addMeal: (_ food: MacroMeal) async throws -> Void
    var updateMeal: (_ food: MacroMeal) async throws -> Void
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
    
    private static func deleteMeal(_ key: DateEntryKey, _ id: UUID) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.authenticationError
        }
        
        // Get Document Id if exists
        guard let documentId = try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(key.value)
            .whereField(Keys.ID.ID, isEqualTo: id.uuidString)
            .getDocuments()
            .documents
            .first?
            .documentID else {
            // ID doesnt exist
            throw AppError.technicalError
        }
        
        // Attempt to delete
        try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(key.value)
            .document(documentId)
            .delete()
    }
    
    private static func deleteTodaysMeal(_ id: UUID) async throws {
        return try await deleteMeal(DateEntryKey(.init()), id)
    }
    
    private static func getMonthMeals(_ key: DateEntryKey) async throws -> [MacroMeal] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.authenticationError
        }
        let documents = try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(key.value)
            .getDocuments()
            .documents
        
        var meals: [MacroMeal] = .init()
        
        for document in documents {
            meals.append(try document.data(as: MacroMeal.self))
        }
        
        return meals
    }

    private static func getDayMeals(_ key: DateEntryKey) async throws -> [MacroMeal] {
        let calender = Calendar(identifier: .iso8601)
        var dayMeals = try await ApiClient.getMonthMeals(key).filter {
            calender.isDate(key.date, equalTo: $0.timeStamp.dateValue(), toGranularity: .day)
        }
        dayMeals.sort {
            $0.timeStamp.dateValue() > $1.timeStamp.dateValue()
        }
        return dayMeals
    }
    
    private static func addMeal(_ food: MacroMeal) async throws -> Void {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.authenticationError
        }
        try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(DateEntryKey(.init()).value)
            .addDocument(data: food.dictionary)
    }
    
    private static func updateMeal(_ food: MacroMeal) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AppError.authenticationError
        }
        
        // Get Document Id if exists
        guard let documentId = try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(food.dateKey.value)
            .whereField(Keys.ID.ID, isEqualTo: food.id.uuidString)
            .getDocuments()
            .documents
            .first?
            .documentID else {
            // ID doesnt exist
            throw AppError.technicalError
        }
        
        // Update the field
        try await Firestore.firestore()
            .collection(Keys.ID.DB)
            .document(uid)
            .collection(food.dateKey.value)
            .document(documentId)
            .updateData(food.dictionary)
    }

    static let liveValue: ApiClient = Self(
        createUser: {
            try await ApiClient.createUser($0, $1)
        }, login: {
            try await ApiClient.login($0, $1)
        }, logout: {
            try ApiClient.logout()
        }, deleteMeal: {
            try await ApiClient.deleteMeal($0, $1)
        }, deleteTodaysMeal: {
            try await ApiClient.deleteTodaysMeal($0)
        }, getMonthMeals: {
            try await ApiClient.getMonthMeals($0)
        }, getDayMeals: {
            try await ApiClient.getDayMeals($0)
        }, addMeal: {
            try await ApiClient.addMeal($0)
        }, updateMeal: {
            try await ApiClient.updateMeal($0)
        }
    )
    
}

// Test Errors
extension ApiClient {
    static let testValue: ApiClient = Self(
        createUser: unimplemented("APIClient.fetchUser"),
        login: unimplemented("APIClient.login"),
        logout: unimplemented("APIClient.logout"),
        deleteMeal: unimplemented("APIClient.deleteMeal"),
        deleteTodaysMeal: unimplemented("APIClient.deleteTodaysMeal"),
        getMonthMeals: unimplemented("APIClient.getMonthMeals"),
        getDayMeals: unimplemented("APIClient.getMonthMeals"),
        addMeal: unimplemented("APIClient.addMeal"),
        updateMeal: unimplemented("APIClient.updateMeal")
    )
}
