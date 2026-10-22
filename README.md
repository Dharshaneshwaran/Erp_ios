# SNS Schools iOS App

A native iOS application built in Swift for the SNS Schools ERP system with login functionality.

## Project Structure

```
SNSSchoolsApp/
├── SNSSchoolsApp/
│   ├── App/
│   │   ├── SNSSchoolsApp.swift          # Main app entry point
│   │   └── AppDelegate.swift             # App lifecycle
│   ├── Network/
│   │   ├── APIClient.swift               # HTTP client for API requests
│   │   └── APIEndpoints.swift            # API endpoint definitions
│   ├── Models/
│   │   ├── Auth/
│   │   │   ├── LoginRequest.swift        # Login payload
│   │   │   ├── AuthResponse.swift        # Auth API response
│   │   │   └── User.swift                # User model
│   │   └── Error/
│   │       └── APIError.swift            # Custom error types
│   ├── Services/
│   │   ├── AuthService.swift             # Authentication service
│   │   └── TokenManager.swift            # JWT token management
│   ├── Views/
│   │   ├── Auth/
│   │   │   ├── LoginView.swift           # Login screen UI
│   │   │   └── AuthViewModel.swift       # Login business logic
│   │   └── Home/
│   │       └── HomeView.swift            # Home screen after login
│   ├── Utilities/
│   │   ├── Constants.swift               # App constants
│   │   └── Extensions.swift              # Helper extensions
│   └── Resources/
│       └── Localization/
│           └── Localizable.strings       # App strings
├── SNSSchoolsAppTests/                   # Unit tests
└── .swiftlint.yml                        # SwiftLint configuration
```

## Setup Instructions

### Requirements
- Xcode 14.0 or later
- iOS 14.0 or later deployment target
- Swift 5.7 or later

### Installation

1. Open the project in Xcode:
   ```bash
   open SNSSchoolsApp.xcodeproj
   ```

2. Select the active scheme and target device

3. Build and run:
   ```bash
   Cmd + R
   ```

## Configuration

Update the API endpoint in `Network/APIEndpoints.swift`:
```swift
let baseURL = "http://your-backend-url:5000"
```

## Features

### Current
- Native Swift UI (SwiftUI)
- User login with email/password
- JWT token management with secure storage (Keychain)
- Token refresh capability
- Error handling and validation

### Future
- Session management
- User profile view
- Dashboard features
- Logout functionality

## Architecture

This app follows MVVM (Model-View-ViewModel) architecture with:
- **Models**: Data structures for API responses and app state
- **Views**: SwiftUI views for UI
- **ViewModels**: Business logic and state management
- **Services**: API communication and token management
- **Network**: HTTP client and endpoint definitions

## Security

- JWT tokens are stored securely in Keychain
- HTTPS is enforced for API communication
- Sensitive credentials are never logged

## Testing

Run unit tests:
```bash
Cmd + U
```

## License

Proprietary - SNS Schools
