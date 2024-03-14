//
//  RuntimeVariablesKey.swift
//  Macroist-SwiftUI
//
//  Created by Ryan Schildknecht on 3/13/24.
//

import ComposableArchitecture
import Foundation

private enum RuntimeVariablesKey: DependencyKey {
  static let liveValue = RuntimeVariables.liveValue
}

extension RuntimeVariablesKey: TestDependencyKey {
  static let testValue = RuntimeVariables.unimplemented
}
