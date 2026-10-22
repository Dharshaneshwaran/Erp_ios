import Foundation

// MARK: - Login Request

struct LoginRequest: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}

// MARK: - Auth Response

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let user: UserProfile
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case expiresIn
        case user
    }
}

// MARK: - User Profile

struct UserProfile: Codable {
    let id: String
    let name: String
    let email: String
    let role: String
    let department: String?
    let status: String?
    let studentProfile: StudentProfileData?
    let teacherProfile: TeacherProfileData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case role
        case department
        case status
        case studentProfile
        case teacherProfile
    }
}

// MARK: - Student Profile Data

struct StudentProfileData: Codable {
    let rollNumber: String?
    let className: String?
    let section: String?
    let dateOfBirth: String?
    
    enum CodingKeys: String, CodingKey {
        case rollNumber
        case className
        case section
        case dateOfBirth
    }
}

// MARK: - Teacher Profile Data

struct TeacherProfileData: Codable {
    let subject: String?
    let employeeId: String?
    let department: String?
    
    enum CodingKeys: String, CodingKey {
        case subject
        case employeeId
        case department
    }
}

// MARK: - Refresh Token Request

struct RefreshTokenRequest: Codable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken
    }
}
