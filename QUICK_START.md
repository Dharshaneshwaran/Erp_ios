# Quick Start Guide

## 60 Second Setup

### Step 1: Open Project
```bash
open SNSSchoolsApp
```

### Step 2: Update Backend URL

Edit `SNSSchoolsApp/Utilities/Constants.swift`:
```swift
static let baseURL = "http://YOUR_IP:5000"
```

Replace `YOUR_IP` with your backend server IP address.

### Step 3: Run

Press `Cmd + R` in Xcode or click the Play button.

---

## Testing Login

### Demo Credentials (from backend .env)

```
Email: admin@sns-erp.local
Password: ChangeMe123!
```

### Steps to Test

1. **Open App**: Login screen appears automatically
2. **Enter Credentials**: Use demo credentials above
3. **Tap Sign In**: Wait for authentication
4. **Success**: You'll see the home screen with your profile

### Expected Results

✅ **Success Path:**
- Credentials accepted
- Tokens saved securely
- Home screen displayed
- Your name shown in welcome message

❌ **Error Cases:**
- Invalid credentials → "Invalid email or password"
- Network error → "Network error: ..."
- Server down → "Server error. Please try again later"

---

## Project Structure Quick Reference

```
SNSSchoolsApp/
├── App/
│   └── SNSSchoolsApp.swift              ← App entry point
├── Network/
│   ├── APIClient.swift                  ← HTTP requests
│   └── APIEndpoints.swift               ← API endpoints
├── Models/
│   ├── Auth/AuthModels.swift            ← Data models
│   └── Error/APIError.swift             ← Error types
├── Services/
│   ├── AuthService.swift                ← Login logic
│   └── TokenManager.swift               ← Token storage
├── Views/
│   ├── Auth/LoginView.swift             ← Login screen
│   └── Home/HomeView.swift              ← Dashboard
└── Utilities/
    ├── Constants.swift                  ← Config
    └── Extensions.swift                 ← Helper methods
```

---

## Common Tasks

### Change Backend URL

**File:** `SNSSchoolsApp/Utilities/Constants.swift`

```swift
struct API {
    static let baseURL = "http://192.168.1.100:5000"
}
```

### Add New API Endpoint

1. Add to `APIEndpoints.swift`:
```swift
static let newEndpoint = "/api/new"
```

2. Create model in `Models/`:
```swift
struct NewResponse: Codable {
    let data: String
}
```

3. Add method in `AuthService.swift`:
```swift
func getNew() async throws -> NewResponse {
    return try await apiClient.get(
        endpoint: APIEndpoints.newEndpoint,
        responseType: NewResponse.self
    )
}
```

### Display Error in UI

Already implemented! Errors automatically show in login view:
```swift
if let errorMessage = authService.errorMessage {
    // Error is displayed
}
```

---

## Troubleshooting

### "Cannot connect to backend"

1. Ensure backend is running:
   ```bash
   curl http://YOUR_IP:5000/auth/me
   ```

2. Check firewall allows port 5000

3. Update IP in `Constants.swift`

4. If using localhost, only works on Simulator

### "Invalid response from server"

1. Verify backend is returning JSON

2. Check response format matches models

3. Look at Xcode Console for detailed error

### App crashes on launch

1. Clean build: `Cmd + Shift + K`

2. Close Xcode completely

3. Reopen project and rebuild

---

## What's Implemented

✅ **Working:**
- Email/password login form
- Real-time field validation
- Secure token storage
- Token expiration handling
- Automatic token refresh
- User profile display
- Logout with confirmation
- Error handling

❌ **Not Yet (Future Versions):**
- Timetable view
- Homework management
- Attendance tracking
- Announcements
- Biometric login
- Push notifications

---

## Need Help?

1. **Setup Issues?** → Read [SETUP.md](SETUP.md)
2. **Architecture Questions?** → Read [ARCHITECTURE.md](ARCHITECTURE.md)
3. **Changes Log?** → Read [CHANGELOG.md](CHANGELOG.md)
4. **Main README?** → Read [README.md](README.md)

---

## Tips & Tricks

### Enable Console Logging

Add to any View:
```swift
.onAppear {
    print("View appeared")
}
```

### Test Token Expiration

1. Get access token: `TokenManager.shared.getAccessToken()`
2. JWT tokens have 1-hour expiration
3. Use web tool to decode JWT and check `exp` value

### Check Keychain Tokens

In Xcode Console:
```swift
print(TokenManager.shared.getAccessToken() ?? "No token")
```

### Force Logout

In Xcode Console or code:
```swift
authService.logout()
```

---

## Performance Notes

- API calls timeout after 30 seconds
- Tokens auto-refresh 1 minute before expiry
- SwiftUI animations enabled for smooth UX
- Minimal memory footprint

---

**Ready to code?** Start by modifying `Constants.swift` with your backend URL, then press `Cmd + R`!

For detailed setup, see [SETUP.md](SETUP.md).
