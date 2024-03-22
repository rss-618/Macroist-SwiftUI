//
//  Ext_String.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/15/24.
//

import Foundation

extension String {
    
    /// Trims whitespace and newlines from string value
    /// - Returns: Trimmed Self
    func trimWhiteSpaceAndNewline() -> Self {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Attempts to convert string value to a CGFloat value.
    /// Will return nil if non-number
    /// - Returns: Optional CGFloat Value
    func toCGFloat() -> CGFloat? {
        if self.trimWhiteSpaceAndNewline().isEmpty {
            return .zero
        } else if let doubleValue = Double(self) {
            return CGFloat(doubleValue)
        } else {
            return nil
        }
    }
    
}
