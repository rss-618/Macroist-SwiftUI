//
//  Ext_Encodable.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 12/20/24.
//

import Foundation

extension Encodable {
    
    /// A getter that translates the object into into a dictionary representation of itself
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    
}
