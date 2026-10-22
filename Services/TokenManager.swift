import Foundation
import Security

/// Manages JWT tokens storage and retrieval using Keychain
class TokenManager {
    static let shared = TokenManager()
    
    private let service = "com.snsschools.app"
    
    // MARK: - Store Token
    
    /// Stores access token in Keychain
    func storeAccessToken(_ token: String) -> Bool {
        return storeToken(token, forKey: Constants.Keychain.accessTokenKey)
    }
    
    /// Stores refresh token in Keychain
    func storeRefreshToken(_ token: String) -> Bool {
        return storeToken(token, forKey: Constants.Keychain.refreshTokenKey)
    }
    
    // MARK: - Retrieve Token
    
    /// Retrieves access token from Keychain
    func getAccessToken() -> String? {
        return retrieveToken(forKey: Constants.Keychain.accessTokenKey)
    }
    
    /// Retrieves refresh token from Keychain
    func getRefreshToken() -> String? {
        return retrieveToken(forKey: Constants.Keychain.refreshTokenKey)
    }
    
    // MARK: - Delete Token
    
    /// Clears all stored tokens
    func clearAllTokens() -> Bool {
        let accessDeleted = deleteToken(forKey: Constants.Keychain.accessTokenKey)
        let refreshDeleted = deleteToken(forKey: Constants.Keychain.refreshTokenKey)
        return accessDeleted && refreshDeleted
    }
    
    // MARK: - Private Helper Methods
    
    private func storeToken(_ token: String, forKey key: String) -> Bool {
        guard let data = token.data(using: .utf8) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // First, try to delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Then add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private func retrieveToken(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    private func deleteToken(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    // MARK: - Token Validation
    
    /// Checks if access token is expired
    func isAccessTokenExpired() -> Bool {
        guard let token = getAccessToken() else {
            return true
        }
        return isTokenExpired(token)
    }
    
    /// Checks if a token is expired
    private func isTokenExpired(_ token: String) -> Bool {
        // JWT format: header.payload.signature
        let parts = token.split(separator: ".")
        guard parts.count == 3 else {
            return true
        }
        
        // Decode payload
        var payload = String(parts[1])
        
        // Add padding if needed
        let padding = 4 - (payload.count % 4)
        if padding != 4 {
            payload += String(repeating: "=", count: padding)
        }
        
        guard let data = Data(base64Encoded: payload),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else {
            return true
        }
        
        // Compare with current time
        return Date().timeIntervalSince1970 > exp
    }
}
