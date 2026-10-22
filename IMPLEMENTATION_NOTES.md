# Implementation Notes

## Project Overview

This document provides detailed implementation notes about how the iOS app was built and how to extend it.

---

## Architecture Decisions

### 1. Why MVVM?

**Decision:** Use Model-View-ViewModel pattern

**Rationale:**
- Native to SwiftUI development
- Clear separation of concerns
- Easy to test
- Reactive state management with @Published
- Industry standard for iOS

**Implementation:**
- Views listen to @Published properties
- ViewModels (Services) contain business logic
- Models define data structures
- Views have no business logic

### 2. Why No External Dependencies?

**Decision:** Use only Foundation, SwiftUI, Security frameworks

**Rationale:**
- Reduces attack surface
- Faster build times
- Easier to maintain
- Better performance
- Simpler onboarding for new developers

**Trade-offs:**
- Manual JSON handling (solved with Codable)
- Manual HTTP client (implemented from scratch)
- No third-party libraries (more control)

### 3. Why Async/Await?

**Decision:** Use async/await for all async operations

**Rationale:**
- Modern Swift concurrency model
- Cleaner code than completion handlers
- Automatic main thread handling with @MainActor
- Type-safe error handling
- Requires iOS 13+, we support iOS 14+

**Implementation:**
```swift
async func login(email: String, password: String) async {
    do {
        let response = try await apiClient.post(...)
    } catch {
        // Handle error
    }
}
```

### 4. Why Keychain for Token Storage?

**Decision:** Store JWT tokens in iOS Keychain

**Rationale:**
- Encrypted storage
- Hardware-backed security on modern iPhones
- Isolated per app
- Survives app reinstalls
- Industry standard

**Implementation:**
```swift
// TokenManager handles all Keychain operations
// Uses kSecAttrAccessibleWhenUnlockedThisDeviceOnly
// No plaintext token storage
```

---

## Key Implementation Details

### JWT Token Management

#### Encoding Strategy
```
1. User logs in with email + password
2. Backend returns JWT (access + refresh tokens)
3. Tokens stored securely in Keychain
4. Each API request includes: "Authorization: Bearer <token>"
5. Token expires after 1 hour
6. App auto-refreshes before expiry
```

#### Token Validation
```swift
// TokenManager checks expiration
private func isTokenExpired(_ token: String) -> Bool {
    // Decode JWT payload (parts[1])
    // Extract exp claim
    // Compare with current time
}
```

### Error Handling

#### Strategy
```
Network Error
    ↓
Catch as URLError
    ↓
Map to APIError enum case
    ↓
ViewModel catches APIError
    ↓
Display to user or retry
```

#### Error Cases Handled
- Invalid URL
- Network connectivity
- HTTP status codes (400, 401, 500, etc.)
- JSON decoding failures
- Token expiration
- Unauthorized access
- Server errors

### Form Validation

#### Real-Time Validation
```swift
var isFormValid: Bool {
    !email.trimmed.isEmpty &&
    email.trimmed.isValidEmail &&
    !password.isEmpty &&
    password.isValidPassword
}
```

#### Visual Feedback
- Green border: Valid input
- Red border: Invalid input
- Gray border: Empty field
- Error message below field
- Submit button enabled only when valid

### State Persistence

#### What Persists
- JWT access token
- JWT refresh token
- User profile (optional)

#### How It Works
```swift
// AppDelegate checks at launch
checkLoginStatus() {
    if let token = getAccessToken() {
        if isExpired(token) {
            refreshToken()
        } else {
            isLoggedIn = true
            fetchUserProfile()
        }
    }
}
```

---

## Code Organization

### File Naming Conventions

```
Views:     [Feature]View.swift       (LoginView.swift)
Models:    [Entity]Models.swift      (AuthModels.swift)
Services:  [Domain]Service.swift     (AuthService.swift)
Network:   API[Layer].swift          (APIClient.swift)
Utils:     [Purpose].swift           (Constants.swift)
```

### Directory Structure

```
Feature-based organization:
- Auth/ (login-related)
- Home/ (dashboard-related)
- Services/ (shared services)
- Network/ (shared networking)
- Models/ (shared data)
```

### Import Organization

```swift
import Foundation      // First
import SwiftUI        // Then SwiftUI
import Security       // Then platform frameworks
// No third-party imports
```

---

## Development Workflow

### Adding New Feature

#### Step 1: Create Model
```swift
// Models/Feature/FeatureModels.swift
struct FeatureResponse: Codable {
    let data: String
}
```

#### Step 2: Add API Endpoint
```swift
// Network/APIEndpoints.swift
static let feature = "/api/feature"
```

#### Step 3: Create Service Method
```swift
// Services/FeatureService.swift
func getFeature() async throws -> FeatureResponse {
    return try await apiClient.get(
        endpoint: APIEndpoints.feature,
        responseType: FeatureResponse.self
    )
}
```

#### Step 4: Create View
```swift
// Views/Feature/FeatureView.swift
struct FeatureView: View {
    @EnvironmentObject var service: FeatureService
    var body: some View {
        // UI code
    }
}
```

### Testing Locally

#### Option 1: Mock Backend
```swift
// For testing without backend
struct MockAPIClient: APIClientProtocol {
    func request(...) async throws -> T {
        // Return mock data
    }
}
```

#### Option 2: Debug Backend
```swift
// Use localhost on simulator
Constants.API.baseURL = "http://localhost:5000"
```

#### Option 3: Network Debugging
```swift
// Log all requests
print("URL: \(request.url)")
print("Method: \(request.httpMethod)")
print("Body: \(String(data: request.httpBody, encoding: .utf8))")
```

---

## Security Considerations

### Implemented
✅ Keychain token storage
✅ HTTPS ready
✅ JWT validation
✅ Input sanitization
✅ Error handling without exposing details
✅ Secure password field

### Not Yet Implemented (Future)
⚠️ Certificate pinning
⚠️ Request signing
⚠️ Biometric authentication
⚠️ Rate limiting
⚠️ Request encryption

### Production Checklist
- [ ] Enable HTTPS
- [ ] Implement certificate pinning
- [ ] Add request signing
- [ ] Implement rate limiting
- [ ] Add analytics tracking
- [ ] Configure ATS properly
- [ ] Test on real device
- [ ] Security review

---

## Performance Optimization

### Current Optimizations
- Single URLSession instance (Singleton)
- Efficient JSON encoding/decoding
- Minimal view re-renders
- Async operations don't block UI
- No memory leaks from strong references

### Potential Improvements
- Implement response caching
- Add request batching
- Use local database (Core Data)
- Implement pagination
- Add image caching
- Optimize view hierarchy

---

## Debugging Techniques

### Enable Console Logging
```swift
// In AppDelegate or any view
print("Login started")
print("Token: \(TokenManager.shared.getAccessToken() ?? "nil")")
print("User: \(authService.currentUser?.name ?? "nil")")
```

### Check Keychain Storage
```swift
// In Xcode console
po TokenManager.shared.getAccessToken()
```

### Network Debugging
```swift
// Enable URLSession debugging
let config = URLSessionConfiguration.default
config.waitsForConnectivity = true
config.timeoutIntervalForRequest = 30
```

### View State Debugging
```swift
@Published var debugState: String? {
    didSet {
        print("State changed: \(debugState ?? "nil")")
    }
}
```

---

## Testing Strategy

### Unit Tests

#### Test AuthService
```swift
func testLoginSuccess() async {
    // Mock successful login
    let result = await authService.login(email: "test@test.com", password: "password")
    XCTAssertTrue(authService.isLoggedIn)
}

func testLoginFailure() async {
    // Mock failed login
    await authService.login(email: "test@test.com", password: "wrong")
    XCTAssertFalse(authService.isLoggedIn)
}
```

#### Test TokenManager
```swift
func testTokenStorage() {
    tokenManager.storeAccessToken("test_token")
    let retrieved = tokenManager.getAccessToken()
    XCTAssertEqual(retrieved, "test_token")
}
```

### UI Tests

#### Test Login Flow
```swift
// XCUITest
let emailField = app.textFields["Email"]
emailField.tap()
emailField.typeText("test@test.com")
// Continue with other fields
```

---

## Common Patterns

### Error Recovery Pattern
```swift
do {
    try operation()
} catch let error as APIError {
    switch error {
    case .unauthorized:
        // Refresh token and retry
        await refreshToken()
        try operation()
    case .serverError:
        // Show retry button
        showErrorWithRetry()
    default:
        // Show error message
        showError(error.description)
    }
}
```

### Loading State Pattern
```swift
@Published var isLoading = false

func loadData() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
        data = try await fetchData()
    } catch {
        errorMessage = error.description
    }
}
```

### Authentication Check Pattern
```swift
func apiRequest() async throws {
    if tokenManager.isAccessTokenExpired() {
        _ = await refreshToken()
    }
    
    let token = tokenManager.getAccessToken()
    let headers = ["Authorization": "Bearer \(token)"]
    
    return try await apiClient.request(..., headers: headers)
}
```

---

## File Size Guide

### Ideal File Sizes
- Views: 150-250 lines
- Services: 150-200 lines
- Models: 50-150 lines
- Network: 150-200 lines
- Utilities: 50-100 lines

### When to Split Files
- If file > 300 lines
- If class has multiple responsibilities
- If file handles multiple domains

---

## Documentation Standards

### Code Comments
```swift
/// Function description
/// - Parameter name: Description
/// - Returns: Description
/// - Throws: Description
func functionName(parameter: Type) -> ReturnType {
    // Implementation
}
```

### File Headers
```swift
// MARK: - Public Methods
// MARK: - Private Methods
// MARK: - Event Handlers
```

### Section Headers
```swift
// MARK: - API Requests
// MARK: - Token Management
// MARK: - Error Handling
```

---

## Version Control

### Commit Message Format
```
feat: Add new feature
fix: Fix bug
docs: Update documentation
refactor: Improve code quality
test: Add tests
```

### Branch Strategy
```
main
├── develop
│   ├── feature/auth-login
│   ├── feature/home-dashboard
│   └── fix/token-expiry
```

---

## Dependency Management

### Current Dependencies
- Foundation
- SwiftUI
- Security (Keychain)

### Adding New Dependencies
⚠️ **Careful!** Evaluate:
1. Do we really need it?
2. Is there a built-in alternative?
3. What's the maintenance burden?
4. Security implications?

### Forbidden Patterns
- ❌ Global variables
- ❌ Singletons (except TokenManager, APIClient)
- ❌ Notifications (use @Published instead)
- ❌ Delegates (use closures instead)
- ❌ UIKit code

---

## Future Enhancements

### Phase 2 Features
- [ ] Implement dashboard
- [ ] Add offline support (Core Data)
- [ ] Implement push notifications
- [ ] Add file upload/download
- [ ] Implement image caching

### Phase 3 Features
- [ ] Biometric authentication
- [ ] Advanced filtering
- [ ] Search functionality
- [ ] Data synchronization
- [ ] Analytics integration

### Technical Debt
- [ ] Add comprehensive unit tests
- [ ] Add UI tests
- [ ] Refactor large views
- [ ] Improve error messages
- [ ] Add performance monitoring

---

## Resources

### Apple Documentation
- [SwiftUI Documentation](https://developer.apple.com/xcode/swiftui/)
- [Concurrency](https://developer.apple.com/documentation/swift/concurrency)
- [Keychain Services](https://developer.apple.com/documentation/security/keychain_services)

### Best Practices
- Follow [Apple Style Guide](https://swift.org/documentation/api-design-guidelines/)
- Use [Swift Language Guide](https://docs.swift.org/swift-book)
- Reference [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)

---

**Last Updated:** October 22, 2024  
**Version:** 1.0.0
