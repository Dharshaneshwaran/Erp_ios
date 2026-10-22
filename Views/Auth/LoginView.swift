import SwiftUI

/// Login view with email and password input
struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var rememberMe = false
    
    var isFormValid: Bool {
        !email.trimmed.isEmpty && 
        !password.isEmpty && 
        email.trimmed.isValidEmail &&
        password.isValidPassword
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.primaryBlue,
                    Color.primaryBlue.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "person.badge.shield")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    
                    Text(Constants.App.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("School Management System")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                
                // Login Form
                VStack(spacing: 20) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Email Address", systemImage: "envelope")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.darkGray)
                        
                        TextField("Enter your email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        email.isEmpty ? Color.lightGray : (email.isValidEmail ? Color.green : Color.errorRed),
                                        lineWidth: 1
                                    )
                            )
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Password", systemImage: "lock")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.darkGray)
                        
                        HStack {
                            if showPassword {
                                TextField("Enter your password", text: $password)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            } else {
                                SecureField("Enter your password", text: $password)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.darkGray)
                            }
                        }
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    password.isEmpty ? Color.lightGray : (password.isValidPassword ? Color.green : Color.errorRed),
                                    lineWidth: 1
                                )
                        )
                    }
                    
                    // Remember Me
                    Toggle("Remember me", isOn: $rememberMe)
                        .font(.system(size: 14))
                        .tint(.primaryBlue)
                    
                    // Error Message
                    if let errorMessage = authService.errorMessage {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.errorRed)
                                Text(errorMessage)
                                    .font(.system(size: 13))
                                    .foregroundColor(.errorRed)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.errorRed.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Login Button
                    Button(action: {
                        Task {
                            await authService.login(email: email, password: password)
                        }
                    }) {
                        if authService.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign In")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        isFormValid && !authService.isLoading
                            ? Color.primaryBlue
                            : Color.primaryBlue.opacity(0.5)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(!isFormValid || authService.isLoading)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService())
}
