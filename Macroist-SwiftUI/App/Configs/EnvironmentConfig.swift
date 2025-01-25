import Foundation

public struct EnvironmentConfig {
    
    public static let shared = EnvironmentConfig()
    
    public let IS_MOCKED = ProcessInfo.processInfo.environment["isMocked"] == "true"
}
