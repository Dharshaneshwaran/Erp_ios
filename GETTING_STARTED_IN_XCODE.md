# Getting Started in Xcode

This guide walks you through opening and running the iOS app in Xcode for the first time.

---

## Prerequisites

Before starting, ensure you have:

1. **Xcode 14.0 or later**
   - Download from Mac App Store
   - Or from [developer.apple.com](https://developer.apple.com)

2. **iOS Simulator or Physical Device**
   - Simulator comes with Xcode
   - Or connect an iPhone/iPad

3. **macOS 12.0 or later**

---

## Step 1: Open the Project in Xcode

### Option A: From Terminal
```bash
cd /mnt/newvolume/sns_school/SNSSchoolsApp
open .
```

Then double-click the app folder in Finder.

### Option B: Drag & Drop
1. Open Finder
2. Navigate to `/mnt/newvolume/sns_school/SNSSchoolsApp`
3. Drag the `SNSSchoolsApp` folder to Xcode

### Option C: Use Xcode Menu
1. Open Xcode
2. File → Open
3. Navigate to `/mnt/newvolume/sns_school/SNSSchoolsApp`
4. Click Open

---

## Step 2: Configure Backend URL

Before running, update the backend API URL:

1. In Xcode, open: `SNSSchoolsApp/Utilities/Constants.swift`

2. Find this line (approximately line 7):
```swift
static let baseURL = "http://localhost:5000"
```

3. Replace with your backend URL:
```swift
// For local development on Simulator:
static let baseURL = "http://localhost:5000"

// For physical device or remote server:
static let baseURL = "http://YOUR_IP_ADDRESS:5000"
// Example: "http://192.168.1.100:5000"
```

4. Save the file (Cmd + S)

---

## Step 3: Select Build Target

1. Look at the top of Xcode window
2. You should see: `SNSSchoolsApp` ► `iPhone Simulator`

3. To change simulator:
   - Click on device name
   - Choose desired iOS device (iPhone 14, iPhone 15, etc.)
   - Or connect a physical iPhone

### Recommended for First Run
- Use iPhone 14 Simulator
- iOS 16 or later

---

## Step 4: Build and Run

### Using Mouse
1. Click the **Play button** (▶) in top-left of Xcode
2. Wait for build to complete
3. Simulator launches with your app

### Using Keyboard
```
Cmd + R    // Build and run
Cmd + B    // Build only
Cmd + .    // Stop execution
```

### First Run Expected
- Build takes 30-60 seconds first time
- Simulator may take a moment to launch
- You should see login screen

---

## Step 5: Test Login

Once the app is running:

1. **See the Login Screen?**
   - App loaded successfully ✓

2. **Enter Test Credentials:**
   ```
   Email:    admin@sns-erp.local
   Password: ChangeMe123!
   ```

3. **Tap "Sign In"**
   - If backend is running: You'll see home screen ✓
   - If backend is down: You'll see error message

---

## Troubleshooting

### Build Fails: "Cannot Load File"
**Solution:**
1. Clean build: Cmd + Shift + K
2. Close Xcode
3. Reopen: `open SNSSchoolsApp`
4. Try again: Cmd + R

### Build Fails: "No such module"
**Solution:**
1. Make sure you opened the right folder
2. Should open folder named `SNSSchoolsApp` (not parent)
3. Cmd + Shift + K to clean
4. Cmd + B to rebuild

### Simulator Won't Start
**Solution:**
1. Quit all simulators
2. Menu: Simulator → Erase All Content and Settings
3. Try Cmd + R again

### Cannot Connect to Backend
**Solution:**
1. Check backend is running on correct port:
   ```bash
   curl http://YOUR_IP:5000/auth/me
   ```

2. Update URL in Constants.swift:
   - Simulator: Use `localhost` or Mac IP
   - Physical device: Use Mac IP (not localhost)

3. Check firewall isn't blocking port 5000

4. Try pinging server:
   ```bash
   ping YOUR_IP
   ```

### Login Returns Error
**Solution:**
1. Check console output (Cmd + Shift + C)
2. Error message tells you the problem
3. Common issues:
   - Wrong backend URL
   - Backend not running
   - Wrong credentials
   - Network unreachable

---

## Common Operations

### View Console Output
- Xcode bottom right: Click "Console" tab
- Or press: Cmd + Shift + C
- Useful for seeing error messages

### Restart App
- Press Cmd + R to rebuild and run
- Or click Play button again

### Stop App
- Press Cmd + . (period)
- Or click Stop button in Xcode

### Check Device Logs
- Window → Devices and Simulators
- Select device
- View Logs

### Change Simulator
- Top of Xcode: Click device selector
- Choose new device
- Cmd + R to run on new device

---

## First Time Checklist

- [ ] Opened project in Xcode
- [ ] Updated backend URL in Constants.swift
- [ ] Selected device/simulator
- [ ] Built successfully (Cmd + B)
- [ ] App launched (Cmd + R)
- [ ] Login screen appeared
- [ ] Entered test credentials
- [ ] Tapped Sign In
- [ ] Got response (success or error)

**If all checked:** App is working correctly! 🎉

---

## Next Steps

### Continue Development
1. Make changes to Swift files
2. Press Cmd + R to rebuild
3. Changes appear in simulator automatically

### Explore the Code
- Start with: `Views/Auth/LoginView.swift`
- Then: `Services/AuthService.swift`
- Then: `Network/APIClient.swift`

### Learn the Structure
- Read: [ARCHITECTURE.md](ARCHITECTURE.md)
- Read: [QUICK_START.md](QUICK_START.md)
- Read: [IMPLEMENTATION_NOTES.md](IMPLEMENTATION_NOTES.md)

### Add New Features
1. Add model in `Models/`
2. Add endpoint in `Network/APIEndpoints.swift`
3. Add service method in `Services/`
4. Add UI in `Views/`

---

## Useful Xcode Shortcuts

| Action | Shortcut |
|--------|----------|
| Build & Run | Cmd + R |
| Build Only | Cmd + B |
| Stop | Cmd + . |
| Clean | Cmd + Shift + K |
| Console | Cmd + Shift + C |
| Find in Project | Cmd + Shift + F |
| Jump to Line | Cmd + G |
| Format Code | Ctrl + I |
| Documentation | Opt + Click |

---

## Tips for Development

### Use Breakpoints
```
1. Click line number to add breakpoint
2. Run with Cmd + R
3. App pauses at breakpoint
4. Use debugger to inspect variables
```

### Enable Console Output
```swift
print("Debug info: \(variableName)")
```

### Use SwiftUI Preview
```swift
#Preview {
    LoginView()
}
```

### Test Different Scenarios
- Use different email/password combinations
- Try network errors (disconnect WiFi)
- Test on different screen sizes

---

## Backend Connection Tips

### Local Development (Simulator)
```swift
// On simulator, use localhost:
static let baseURL = "http://localhost:5000"
```

### Local Development (Physical Device)
```swift
// On device, use your Mac's IP:
static let baseURL = "http://192.168.1.100:5000"
// Find your IP: ifconfig | grep "inet "
```

### Remote Backend
```swift
// For deployed backend:
static let baseURL = "http://your-server.com:5000"
// or
static let baseURL = "https://your-server.com"
```

---

## Performance Tips

### Build Times
- First build: 30-60 seconds
- Incremental builds: 5-15 seconds
- Use Cmd + B to build without running

### Simulator Performance
- Newer simulators are faster
- iPhone 14 simulator is recommended
- Older simulators may be slow

### Memory Management
- Close other apps
- Use Activity Monitor to check Mac RAM
- Restart Xcode if it gets slow

---

## Getting Help

### In Xcode
1. Select a symbol/method
2. Press Option (Alt) + Click
3. See documentation popup

### Online Resources
- [SwiftUI Documentation](https://developer.apple.com/xcode/swiftui/)
- [Swift Language Guide](https://docs.swift.org/swift-book)
- [Apple Developer Forum](https://developer.apple.com/forums/)

### Project Documentation
- [README.md](README.md) - Overview
- [SETUP.md](SETUP.md) - Installation
- [QUICK_START.md](QUICK_START.md) - Quick guide
- [ARCHITECTURE.md](ARCHITECTURE.md) - Design

---

## Summary

1. **Open project** in Xcode
2. **Update URL** in Constants.swift
3. **Press Cmd+R** to build and run
4. **Test login** with provided credentials
5. **Explore code** and build features

**You're all set to start developing!**

---

**Questions?** See the troubleshooting section above or check the documentation files.

**Ready to code?** Press Cmd+R and go! 🚀
