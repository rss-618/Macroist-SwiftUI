//
//  Ext_Float.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 4/5/24.
//

import Foundation

extension CGFloat {
    
    /// Converts value to string to specified decimal points
    /// - Parameter places: amount of decimal points
    /// - Returns: rounded string value
    public func roundToString(_ places: Int) -> String {
        String(format: "%.\(places)f", self)
    }
    
    
    /// Gets a string representation of a CGFloat that is not zero, If zero it will return empty string
    public var nonZeroString: String {
        self == 0 ? .init() : self.description
    }
    
}
