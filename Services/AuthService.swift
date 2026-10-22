import Foundation

/// Handles authentication operations including login and token refresh
class AuthService: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiClient = APIClient.shared
    private let tokenManager = TokenManager.shared
    
    init() {
        // Check if user is already logged in
        checkLoginStatus()
    }
    
    // MARK: - Login
    
    /// Attempts to login with email and password
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    func login(email: String, password: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let loginRequest = LoginRequest(email: email, password: password)
            let response: AuthResponse = try await apiClient.post(
                endpoint: APIEndpoints.login,
                body: loginRequest,
                responseType: AuthResponse.self
            )
            
            // Store tokens
            let accessStored = tokenManager.storeAccessToken(response.accessToken)
            let refreshStored = tokenManager.storeRefreshToken(response.refreshToken)
            
            guard accessStored && refreshStored else {
                throw APIError.invalidRequest
            }
            
            // Update app state
            DispatchQueue.main.async {
                self.currentUser = response.user
                self.isLoggedIn = true
                self.isLoading = false
            }
        } catch let error as APIError {
            DispatchQueue.main.async {
                self.errorMessage = error.errorDescription
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "An unexpected error occurred"
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Logout
    
    /// Clears user session and logs out
    func logout() {
        tokenManager.clearAllTokens()
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isLoggedIn = false
            self.errorMessage = nil
        }
    }
    
    // MARK: - Token Refresh
    
    /// Refreshes the access token using refresh token
    func refreshToken() async -> Bool {
        guard let refreshToken = tokenManager.getRefreshToken() else {
            logout()
            return false
        }
        
        do {
            let refreshRequest = RefreshTokenRequest(refreshToken: refreshToken)
            let response: AuthResponse = try await apiClient.post(
                endpoint: APIEndpoints.refresh,
                body: refreshRequest,
                responseType: AuthResponse.self
            )
            
            // Store new tokens
            let accessStored = tokenManager.storeAccessToken(response.accessToken)
            let refreshStored = tokenManager.storeRefreshToken(response.refreshToken)
            
            return accessStored && refreshStored
        } catch {
            logout()
            return false
        }
    }
    
    // MARK: - User Profile
    
    /// Fetches current user profile
    func fetchUserProfile() async {
        guard let token = tokenManager.getAccessToken() else {
            logout()
            return
        }
        
        do {
            let headers = ["Authorization": "Bearer \(token)"]
            let response: UserProfile = try await apiClient.get(
                endpoint: APIEndpoints.profile,
                headers: headers,
                responseType: UserProfile.self
            )
            
            DispatchQueue.main.async {
                self.currentUser = response
            }
        } catch let error as APIError {
            if case .unauthorized = error {
                // Try to refresh token
                let refreshed = await refreshToken()
                if refreshed {
                    // Retry fetching profile
                    await fetchUserProfile()
                } else {
                    logout()
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = error.errorDescription
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch profile"
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Checks if user is already logged in
    private func checkLoginStatus() {
        if let token = tokenManager.getAccessToken() {
            // Token exists, but check if it's expired
            if tokenManager.isAccessTokenExpired() {
                // Try to refresh
                Task {
                    let refreshed = await refreshToken()
                    if refreshed {
                        await fetchUserProfile()
                    } else {
                        DispatchQueue.main.async {
                            self.isLoggedIn = false
                        }
                    }
                }
            } else {
                // Token is valid
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
                Task {
                    await fetchUserProfile()
                }
            }
        }
    }
}
