//
//  Tab.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/11/24.
//

import Foundation

public enum Tab: Equatable, CaseIterable {
    case history
    case today
    case settings
    
    public var text: String {
        switch self {
        case .history:
            "History"
        case .today:
            "Today"
        case .settings:
            "Settings"
        }
    }
    
    public var iconName: String {
        switch self {
        case .history:
            Keys.SystemIcon.CLOCK
        case .today:
            Keys.SystemIcon.CALENDAR_CIRCLE
        case .settings:
            Keys.SystemIcon.GEARSHAPE
        }
    }
}
