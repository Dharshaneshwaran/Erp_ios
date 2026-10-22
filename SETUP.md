# iOS App Setup Guide

## Prerequisites

Before setting up the iOS app, ensure you have:

- **Xcode 14.0 or later** - [Download from App Store](https://apps.apple.com/app/xcode/id497799835)
- **macOS 12.0 or later**
- **Swift 5.7 or later** (comes with Xcode)
- **iOS 14.0 or later** deployment target

## Installation Steps

### 1. Clone the Repository

```bash
cd /mnt/newvolume/sns_school
```

### 2. Open in Xcode

```bash
# If you want to use Tuist (recommended for larger projects)
tuist install
tuist generate
open SNSSchoolsApp.xcworkspace

# Or directly open the app bundle
open SNSSchoolsApp
```

### 3. Configure API Endpoint

Update the API endpoint in `SNSSchoolsApp/Utilities/Constants.swift`:

```swift
struct API {
    // Change this to your backend URL
    static let baseURL = "http://your-backend-ip:5000"
}
```

For local development:
- On simulator: Use your Mac's IP address (e.g., `http://192.168.x.x:5000`)
- On physical device: Same as above
- Using localhost: Only works on simulator with `http://localhost:5000`

### 4. Build and Run

**Using Xcode:**
1. Select target device (iPhone Simulator or physical device)
2. Press `Cmd + R` to build and run
3. Or click the Play button in Xcode

**Using Command Line:**
```bash
xcodebuild -scheme SNSSchoolsApp -configuration Debug -destination 'generic/platform=iOS Simulator' build
```

## Project Structure

```
SNSSchoolsApp/
├── App/                          # App entry point and configuration
│   └── SNSSchoolsApp.swift       # Main app initialization
├── Network/                      # API communication
│   ├── APIClient.swift           # HTTP client with async/await
│   └── APIEndpoints.swift        # Endpoint definitions
├── Models/                       # Data models
│   ├── Auth/                     # Authentication models
│   │   └── AuthModels.swift      # Login, token, user models
│   └── Error/
│       └── APIError.swift        # Custom error types
├── Services/                     # Business logic
│   ├── AuthService.swift         # Login and token management
│   └── TokenManager.swift        # JWT token storage (Keychain)
├── Views/                        # SwiftUI components
│   ├── Auth/
│   │   └── LoginView.swift       # Login screen
│   └── Home/
│       └── HomeView.swift        # Dashboard after login
├── Utilities/                    # Helper functions
│   ├── Constants.swift           # App-wide constants
│   └── Extensions.swift          # String, Color, View extensions
└── Resources/                    # Assets and localization
```

## Key Features

### SwiftUI-Based
- Modern UI built entirely with SwiftUI
- No UIKit dependencies
- Responsive design for all iOS 14+ devices

### Secure Authentication
- JWT token management using Keychain
- Automatic token refresh on expiration
- Secure credential storage

### Network Layer
- Generic async/await based API client
- Automatic error handling
- Request/response model mapping

### State Management
- MVVM architecture pattern
- @Published properties for reactive updates
- @EnvironmentObject for dependency injection

## Development

### Adding New API Endpoints

1. Add endpoint in `Network/APIEndpoints.swift`:
```swift
static let newEndpoint = "/path/to/endpoint"
```

2. Create response model in `Models/`:
```swift
struct NewResponse: Codable {
    let data: String
}
```

3. Add method in `Services/AuthService.swift`:
```swift
func newMethod() async throws -> NewResponse {
    return try await apiClient.get(
        endpoint: APIEndpoints.newEndpoint,
        headers: authHeaders(),
        responseType: NewResponse.self
    )
}
```

### Adding Authentication Header

Use the helper method in AuthService:
```swift
private func authHeaders() -> [String: String] {
    guard let token = tokenManager.getAccessToken() else {
        return [:]
    }
    return ["Authorization": "Bearer \(token)"]
}
```

## Testing

### Run Unit Tests

```bash
# Using Xcode
Cmd + U

# Using command line
xcodebuild test -scheme SNSSchoolsApp
```

### Manual Testing Checklist

- [ ] Login with valid credentials
- [ ] Login fails with invalid credentials
- [ ] Tokens are stored securely
- [ ] Token refresh works automatically
- [ ] Logout clears all credentials
- [ ] App persists login state on restart
- [ ] Network errors are handled gracefully

## Troubleshooting

### Cannot Connect to Backend

**Issue:** "Network error" on login attempt

**Solution:**
1. Verify backend is running: `curl http://your-ip:5000/auth/me`
2. Check firewall settings allow port 5000
3. On iOS device, ensure both device and Mac are on same network
4. Update `Constants.swift` with correct IP address

### Keychain Errors

**Issue:** Tokens not being stored

**Solution:**
1. Verify running on actual iOS device or simulator with Keychain support
2. Check app has entitlements for Keychain access
3. Look at Console output for specific Keychain error codes

### SwiftUI Preview Not Working

**Issue:** Preview shows "Failed to build"

**Solution:**
1. Clean build folder: `Cmd + Shift + K`
2. Close and reopen Xcode
3. Update `#Preview` macro at bottom of view file

## Performance Optimization

- **API Response Caching**: Consider implementing caching for frequently accessed endpoints
- **Background Refresh**: Use URLSession background refresh for notifications
- **Memory Management**: Monitor token refresh frequency to avoid excessive network calls
- **UI Responsiveness**: All network calls use async/await to prevent main thread blocking

## Security Considerations

✅ **Implemented:**
- JWT tokens stored in Keychain (encrypted)
- Automatic token expiration validation
- HTTPS ready (configured for production)
- No hardcoded secrets in code
- Secure password field masking

⚠️ **For Production:**
- Implement Certificate Pinning for HTTPS
- Add rate limiting to prevent brute force
- Implement biometric authentication (Face ID/Touch ID)
- Add request signing for sensitive operations
- Enable App Transport Security (ATS) strictest rules

## FAQ

**Q: Can I run this on an iPad?**
A: Yes! The app targets iOS 14+, which includes iPad OS.

**Q: Do I need a paid Apple Developer account?**
A: No, you can develop with a free account. Paid account needed only for App Store distribution.

**Q: How do I handle 3G/4G connectivity?**
A: The APIClient has timeout handling and error recovery built-in. Network reachability can be added using NWPathMonitor.

**Q: Can I use this with other backends?**
A: Yes! The network layer is generic. Update APIEndpoints.swift and modify models as needed.

## Support

For issues or questions:
1. Check the [README.md](README.md) for overview
2. Review code comments in each file
3. Check Xcode Console for error messages
4. Verify backend API is responding correctly

## Next Steps

After login is working:
1. Implement dashboard/home screen features
2. Add user profile management
3. Implement additional API endpoints
4. Add offline support with local caching
5. Implement push notifications (FCM)
6. Add unit and UI tests
7. Prepare for App Store submission

---

**Last Updated:** October 22, 2024  
**Version:** 1.0.0
