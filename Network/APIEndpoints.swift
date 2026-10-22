import Foundation

/// API Endpoints configuration
struct APIEndpoints {
    /// Base URL for all API requests
    static let baseURL = Constants.API.baseURL
    
    /// Login endpoint
    static let login = "/auth/login"
    
    /// Refresh token endpoint
    static let refresh = "/auth/refresh"
    
    /// Get current user profile
    static let profile = "/auth/me"
    
    /// Build full URL from endpoint
    static func fullURL(_ endpoint: String) -> URL? {
        return URL(string: baseURL + endpoint)
    }
}
