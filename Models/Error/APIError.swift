import Foundation
import URLRouting

/// API Error types for handling various network and parsing errors
enum APIError: LocalizedError {
    case invalidURL
    case invalidRequest
    case networkError(Error)
    case invalidResponse
    case httpError(statusCode: Int, message: String)
    case decodingError(Error)
    case tokenExpired
    case unauthorized
    case serverError
    case unknown(Error?)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidRequest:
            return "Invalid request"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode, let message):
            return "HTTP \(statusCode): \(message)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .tokenExpired:
            return "Your session has expired. Please login again."
        case .unauthorized:
            return "Unauthorized. Please check your credentials."
        case .serverError:
            return "Server error. Please try again later."
        case .unknown(let error):
            return error?.localizedDescription ?? "An unknown error occurred"
        }
    }
}

/// Response error from API
struct ErrorResponse: Codable {
    let message: String?
    let error: String?
    
    var displayMessage: String {
        return message ?? error ?? "An error occurred"
    }
}
