import Foundation

/// Application constants
struct Constants {
    // MARK: - API Configuration
    struct API {
        // Change this to your backend URL
        static let baseURL = "http://localhost:5000"
        
        // Endpoints
        static let loginEndpoint = "/auth/login"
        static let refreshEndpoint = "/auth/refresh"
        static let meEndpoint = "/auth/me"
    }
    
    // MARK: - Keychain Keys
    struct Keychain {
        static let accessTokenKey = "com.snsschools.auth.accessToken"
        static let refreshTokenKey = "com.snsschools.auth.refreshToken"
        static let userProfileKey = "com.snsschools.auth.userProfile"
    }
    
    // MARK: - App Configuration
    struct App {
        static let name = "SNS Schools"
        static let version = "1.0.0"
        static let buildNumber = "1"
    }
    
    // MARK: - Validation
    struct Validation {
        static let minPasswordLength = 6
        static let minEmailLength = 5
    }
    
    // MARK: - Network Configuration
    struct Network {
        static let timeoutInterval: TimeInterval = 30.0
        static let retryAttempts = 3
    }
}
