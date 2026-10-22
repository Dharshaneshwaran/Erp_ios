# Architecture Overview

## Design Pattern: MVVM (Model-View-ViewModel)

The iOS app follows the Model-View-ViewModel (MVVM) architectural pattern, which provides clear separation of concerns and is ideal for SwiftUI applications.

### Architecture Layers

```
┌─────────────────────────────────────────────────┐
│                   SwiftUI Views                 │
│         (LoginView, HomeView, etc.)             │
└────────────────────┬────────────────────────────┘
                     │ Uses
                     ▼
┌─────────────────────────────────────────────────┐
│                 ViewModels                      │
│        (AuthService handles state)              │
└────────────────────┬────────────────────────────┘
                     │ Uses
                     ▼
┌─────────────────────────────────────────────────┐
│                  Services                       │
│   (AuthService, TokenManager)                   │
└────────────────────┬────────────────────────────┘
                     │ Uses
                     ▼
┌─────────────────────────────────────────────────┐
│               Network Layer                     │
│        (APIClient, APIEndpoints)                │
└────────────────────┬────────────────────────────┘
                     │ Uses
                     ▼
┌─────────────────────────────────────────────────┐
│                   Models                        │
│   (AuthResponse, UserProfile, etc.)             │
└─────────────────────────────────────────────────┘
```

## Component Descriptions

### 1. Views (UI Layer)

**Location:** `SNSSchoolsApp/Views/`

Views are responsible for displaying UI and handling user interactions. Built entirely with SwiftUI.

**Key Views:**
- `LoginView.swift`: Email/password login form
- `HomeView.swift`: Dashboard after login

**Characteristics:**
- Read-only access to @EnvironmentObject services
- Pass user actions to ViewModels
- Reactive to state changes via @Published properties
- No business logic

### 2. ViewModels (Presentation Logic)

**Location:** `SNSSchoolsApp/Services/`

ViewModels (implemented as Services here) bridge Views and Models. They contain presentation logic and state management.

**Key ViewModels:**
- `AuthService.swift`: Manages login state, token refresh, and user profile

**Characteristics:**
- ObservableObject with @Published properties
- Async/await methods for operations
- Handles data transformation for UI
- Manages user session state

### 3. Services (Business Logic)

**Location:** `SNSSchoolsApp/Services/`

Services encapsulate reusable business logic and external integrations.

**Key Services:**
- `AuthService`: Authentication and session management
- `TokenManager`: JWT token storage and validation

**Characteristics:**
- Stateless operations
- Focus on specific domains
- Can be injected into ViewModels/Views
- Handle integration with Network Layer

### 4. Network Layer

**Location:** `SNSSchoolsApp/Network/`

Handles all API communication with the backend.

**Components:**
- `APIClient.swift`: Generic HTTP client with async/await
- `APIEndpoints.swift`: Centralized endpoint definitions

**Characteristics:**
- Generic request handling
- Error mapping and handling
- Automatic JSON encoding/decoding
- Request/response model validation

### 5. Models (Data)

**Location:** `SNSSchoolsApp/Models/`

Define data structures for API requests/responses and app state.

**Key Models:**
- `AuthResponse`: Login API response
- `UserProfile`: User data
- `LoginRequest`: Login payload
- `APIError`: Error types

**Characteristics:**
- Codable for JSON serialization
- Immutable value types
- No business logic
- Clear representation of API contracts

## Data Flow

### Login Flow

```
LoginView (User enters credentials)
    ↓
AuthService.login(email, password)
    ↓
APIClient.post(login endpoint, LoginRequest)
    ↓
Backend returns AuthResponse
    ↓
TokenManager stores tokens in Keychain
    ↓
AuthService.isLoggedIn = true
    ↓
HomeView is displayed
```

### Token Refresh Flow

```
APIClient detects 401 Unauthorized
    ↓
AuthService.refreshToken()
    ↓
TokenManager retrieves refresh token from Keychain
    ↓
APIClient.post(refresh endpoint, RefreshTokenRequest)
    ↓
Backend returns new AuthResponse
    ↓
TokenManager updates tokens in Keychain
    ↓
Original request is retried
```

## State Management

### AuthService (@Published Properties)

```swift
@Published var isLoggedIn: Bool          // Login state
@Published var currentUser: UserProfile? // User data
@Published var isLoading: Bool           // Loading indicator
@Published var errorMessage: String?     // Error display
```

### SwiftUI Reactive Binding

Views automatically update when published properties change:

```swift
struct LoginView: View {
    @EnvironmentObject var authService: AuthService // Access published state
    
    var body: some View {
        if authService.isLoading {
            ProgressView() // Reactive update
        }
    }
}
```

## Error Handling Strategy

### Error Types

```
APIError (enum)
├── invalidURL
├── networkError(Error)
├── httpError(statusCode, message)
├── decodingError(Error)
├── unauthorized
├── tokenExpired
└── unknown(Error?)
```

### Error Flow

```
Network Request
    ↓
Catches URLError or throws APIError
    ↓
Maps to specific APIError case
    ↓
ViewModel (AuthService) catches and displays
    ↓
View shows errorMessage to user
```

## Security Architecture

### Token Storage

- **Location:** iOS Keychain (encrypted)
- **Access Control:** WhenUnlockedThisDeviceOnly
- **Managed by:** TokenManager

### Token Validation

```
Request initiated
    ↓
Check if token exists
    ↓
Is token expired?
    └─→ Yes: Attempt refresh
    └─→ No: Use token
    ↓
Attach token to Authorization header
    ↓
Send request
```

### Secure Coding Practices

✅ Implemented:
- No hardcoded secrets
- Keychain for token storage
- JWT expiration validation
- HTTPS ready
- Secure password field masking
- No PII in logs

## Extensibility Points

### Adding New API Endpoints

1. **Add to APIEndpoints:**
```swift
static let newEndpoint = "/api/new"
```

2. **Create Model:**
```swift
struct NewResponse: Codable { ... }
```

3. **Add Service Method:**
```swift
func newMethod() async throws -> NewResponse {
    return try await apiClient.get(...)
}
```

4. **Update View:**
```swift
@State private var data: NewResponse?
Task { data = try await service.newMethod() }
```

### Adding New Views

1. Create in `Views/` directory
2. Add as a case in main navigation
3. Use @EnvironmentObject to access services
4. Bind to @Published properties

## Performance Considerations

### API Client Optimization

- **Timeout:** 30 seconds per request
- **Retry Logic:** Configurable (default 3 attempts)
- **JSON Parsing:** Efficient JSONDecoder
- **Concurrent Requests:** Supported via async/await

### Memory Management

- Views are released when dismissed
- Tokens held in memory only when needed
- @StateObject ensures proper lifecycle
- No circular references

### Network Efficiency

- Single APIClient instance (Singleton)
- URL session configuration optimized
- No request duplication
- Efficient JSON encoding/decoding

## Testing Strategy

### Unit Tests

- Mock APIClient for network testing
- Test TokenManager separately
- Test AuthService state transitions
- Validate error handling

### UI Tests

- Test login flow
- Verify error messages
- Check logout functionality
- Validate state persistence

## Future Enhancements

### Phase 2

- [ ] Implement caching layer (URLCache + custom storage)
- [ ] Add offline support with Core Data
- [ ] Implement biometric authentication
- [ ] Add analytics tracking
- [ ] Implement feature flags

### Phase 3

- [ ] Add push notifications (FCM)
- [ ] Implement deep linking
- [ ] Add background refresh
- [ ] Implement request signing
- [ ] Add certificate pinning

### Phase 4

- [ ] Multi-language support (Localization)
- [ ] Dark mode optimization
- [ ] Accessibility improvements
- [ ] Performance monitoring
- [ ] Crash reporting

---

This architecture ensures the app is maintainable, testable, and scalable as features are added.
