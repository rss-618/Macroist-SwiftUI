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
struct ApiClient: DependencyKey {
    
    static let liveValue: ApiClient = Self(
        createUser: {
            try await ApiService.shared.createUser(email: $0, password: $1)
        }, login: {
            try await ApiService.shared.login(email: $0, password: $1)
        }, logout: {
            try await ApiService.shared.logout()
        }, deleteMeal: {
            try await ApiService.shared.deleteMeal(key: $0, id: $1)
        }, deleteTodaysMeal: {
            try await ApiService.shared.deleteTodaysMeal(id: $0)
        }, getMonthMeals: {
            try await ApiService.shared.getMonthMeals(key: $0)
        }, getDayMeals: {
            try await ApiService.shared.getDayMeals(key: $0)
        }, addMeal: {
            try await ApiService.shared.addMeal(food: $0)
        }, updateMeal: {
            try await ApiService.shared.updateMeal(food: $0)
        }
    )
    
    static let mockValue: ApiClient = Self(
        createUser: {
            try await ApiService.mock.createUser(email: $0, password: $1)
        }, login: {
            try await ApiService.mock.login(email: $0, password: $1)
        }, logout: {
            try await ApiService.mock.logout()
        }, deleteMeal: {
            try await ApiService.mock.deleteMeal(key: $0, id: $1)
        }, deleteTodaysMeal: {
            try await ApiService.mock.deleteTodaysMeal(id: $0)
        }, getMonthMeals: {
            try await ApiService.mock.getMonthMeals(key: $0)
        }, getDayMeals: {
            try await ApiService.mock.getDayMeals(key: $0)
        }, addMeal: {
            try await ApiService.mock.addMeal(food: $0)
        }, updateMeal: {
            try await ApiService.mock.updateMeal(food: $0)
        }
    )
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
    
    // --- Firebase Calls ---
    // Included within a dependancy for testing and abstraction purposes\
    // -- Auth --
    var createUser: (_ email: String,
                     _ password: String) async throws -> Void
    var login: (_ email: String,
                _ password: String) async throws -> Void
    var logout: () async throws ->  Void
    // -- Database --
    var deleteMeal: (DateEntryKey, UUID) async throws -> Void
    var deleteTodaysMeal: (UUID) async throws -> Void
    var getMonthMeals: (DateEntryKey) async throws -> [MacroMeal]
    var getDayMeals: (DateEntryKey) async throws -> [MacroMeal]
    var addMeal: (_ food: MacroMeal) async throws -> Void
    var updateMeal: (_ food: MacroMeal) async throws -> Void
    // --- End Firebase Calls --
}
