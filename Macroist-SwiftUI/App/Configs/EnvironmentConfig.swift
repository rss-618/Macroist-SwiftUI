//
//  EnvironmentConfig.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/10/24.
//

import Foundation

public struct EnvironmentConfig {
    public static let IS_MOCKED = ProcessInfo.processInfo.environment["MOCK_NETWORK"] == "true"
}
