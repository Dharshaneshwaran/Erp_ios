import SwiftUI

/// Home view displayed after successful login
struct HomeView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.lightGray
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.darkGray)
                        
                        if let user = authService.currentUser {
                            Text(user.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primaryBlue)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.white)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 20) {
                            // User Info Card
                            if let user = authService.currentUser {
                                UserInfoCard(user: user)
                            }
                            
                            // Placeholder for future features
                            VStack(spacing: 16) {
                                Text("Additional Features")
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                FeatureCard(
                                    icon: "calendar",
                                    title: "Timetable",
                                    subtitle: "View your class schedule",
                                    color: .blue
                                )
                                
                                FeatureCard(
                                    icon: "book",
                                    title: "Homework",
                                    subtitle: "Check assigned homework",
                                    color: .green
                                )
                                
                                FeatureCard(
                                    icon: "chart.bar",
                                    title: "Attendance",
                                    subtitle: "Track attendance record",
                                    color: .orange
                                )
                            }
                            .padding(20)
                        }
                        .padding(.vertical, 20)
                    }
                    
                    // Logout Button
                    Button(action: { showingLogoutAlert = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .foregroundColor(.white)
                        .background(Color.errorRed)
                        .cornerRadius(8)
                    }
                    .padding(20)
                }
            }
            .alert("Confirm Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    authService.logout()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}

// MARK: - User Info Card

struct UserInfoCard: View {
    let user: UserProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.primaryBlue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.darkGray)
                    
                    Text(user.email)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack(spacing: 16) {
                InfoField(label: "Role", value: user.role.capitalized)
                
                if let department = user.department {
                    InfoField(label: "Department", value: department)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - Feature Card

struct FeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.darkGray)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
    }
}

// MARK: - Info Field

struct InfoField: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.darkGray)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject({
            let service = AuthService()
            service.currentUser = UserProfile(
                id: "1",
                name: "John Doe",
                email: "john@example.com",
                role: "student",
                department: "Science",
                status: "active",
                studentProfile: nil,
                teacherProfile: nil
            )
            return service
        }())
}
