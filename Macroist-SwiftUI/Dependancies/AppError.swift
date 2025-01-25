//
//  AppError.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/10/24.
//

import Foundation

public enum AppError: Error, Equatable {
    case status(code: Int)
    case technicalError
}
