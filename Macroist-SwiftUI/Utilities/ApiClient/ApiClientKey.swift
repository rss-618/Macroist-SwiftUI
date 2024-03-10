//
//  ApiClientKey.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/8/24.
//

import ComposableArchitecture
import Foundation

private enum ApiClientKey: DependencyKey {
  static let liveValue = ApiClient.liveValue
}

extension ApiClient: TestDependencyKey {
  static let testValue = ApiClient.unimplemented
}
