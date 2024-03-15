//
//  DateUtil.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/15/24.
//

import Foundation
import FirebaseFirestore

public struct DateUtil {
    
    /// A Firestore collection location/creation key utility function
    /// The firestore is structured in a certain way of meals/{userUID}/{month-year} to locate meals
    /// - Parameter date: Used to get the month and year to query the database
    /// - Returns: Formatted Key
    public static func getMonthYearEntryKey(_ date: Date = .init()) -> String {
        return "\(date.get(.month))-\(date.get(.year))"
    }
    
    /// A Firestore collection location/creation key utility function
    /// The firestore is structured in a certain way of meals/{userUID}/{month-year} to locate meals
    /// - Parameter month: Month Integer
    /// - Parameter year: Year Integer
    /// - Returns: Formatted Key
    public static func getMonthYearEntryKey(_ month: Int, year: Int) -> String {
        return "\(month)-\(year)"
    }
}
