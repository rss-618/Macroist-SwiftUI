//
//  MonthEntryKey.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 12/20/24.
//

import SwiftUI

public struct DateEntryKey: Equatable {
    
    let date: Date
    let value: String
    
    // Initialize DateEntryKey from Date object.
    // Defaults to current day.
    public init(_ date: Date = .init()) {
        self.date = date
        self.value = DateEntryKey.getMonthYearEntryKey(date)
    }
    
    // Initialize DateEntryKey from month and year.
    public init(month: Int, year: Int) throws {
        guard let date = DateComponents(year: year, month: month).date else {
            throw AppError.technicalError
        }
        self.date = date
        self.value = DateEntryKey.getMonthYearEntryKey(date)
    }
    
    /// A Firestore collection location/creation key utility function
    /// The firestore is structured in a certain way of meals/{userUID}/{month-year} to locate meals
    /// - Parameter date: Used to get the month and year to query the database
    /// - Returns: Formatted Key
    private static func getMonthYearEntryKey(_ date: Date = .init()) -> String {
        return "\(date.get(.month))-\(date.get(.year))"
    }

}
