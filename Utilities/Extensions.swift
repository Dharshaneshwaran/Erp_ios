import Foundation
import SwiftUI

// MARK: - String Extensions

extension String {
    /// Validates if the string is a valid email format
    var isValidEmail: Bool {
        let emailPattern = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailPattern).evaluate(with: self)
    }
    
    /// Validates if the string meets minimum length requirement for password
    var isValidPassword: Bool {
        return self.count >= Constants.Validation.minPasswordLength
    }
    
    /// Trims whitespace from both ends
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

// MARK: - Color Extensions

extension Color {
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let lightGray = Color(UIColor(white: 0.95, alpha: 1.0))
    static let darkGray = Color(UIColor(white: 0.3, alpha: 1.0))
    static let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)
}

// MARK: - View Extensions

extension View {
    /// Applies a conditional modifier
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Date Extensions

extension Date {
    /// Returns a formatted string representation of the date
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
}
