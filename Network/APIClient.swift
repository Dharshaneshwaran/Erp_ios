import Foundation

/// HTTP Client for making API requests
class APIClient {
    static let shared = APIClient()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init() {
        // Configure URLSession
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.Network.timeoutInterval
        config.timeoutIntervalForResource = Constants.Network.timeoutInterval
        config.waitsForConnectivity = true
        
        self.session = URLSession(configuration: config)
        
        // Configure JSON decoder
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        
        // Configure JSON encoder
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - Generic Request Method
    
    /// Makes a generic HTTP request
    /// - Parameters:
    ///   - endpoint: The API endpoint
    ///   - method: HTTP method (default: GET)
    ///   - body: Request body (optional)
    ///   - headers: Additional headers (optional)
    ///   - responseType: Expected response type
    /// - Returns: Decoded response of type T
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        // Build URL
        guard let url = APIEndpoints.fullURL(endpoint) else {
            throw APIError.invalidURL
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Set default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add custom headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Set request body
        if let body = body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                throw APIError.decodingError(error)
            }
        }
        
        // Perform request
        do {
            let (data, response) = try await session.data(for: request)
            
            // Validate response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Handle HTTP status codes
            switch httpResponse.statusCode {
            case 200...299:
                // Success
                break
            case 401:
                throw APIError.unauthorized
            case 400...499:
                // Try to decode error message
                if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                    throw APIError.httpError(statusCode: httpResponse.statusCode, message: errorResponse.displayMessage)
                } else {
                    throw APIError.httpError(statusCode: httpResponse.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            case 500...599:
                throw APIError.serverError
            default:
                throw APIError.httpError(statusCode: httpResponse.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
            }
            
            // Decode response
            do {
                let decodedResponse = try decoder.decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch let error as URLError {
            throw APIError.networkError(error)
        } catch {
            throw APIError.unknown(error)
        }
    }
    
    // MARK: - Convenience Methods
    
    /// GET request
    func get<T: Decodable>(
        endpoint: String,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .get,
            headers: headers,
            responseType: responseType
        )
    }
    
    /// POST request
    func post<T: Decodable>(
        endpoint: String,
        body: Encodable,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .post,
            body: body,
            headers: headers,
            responseType: responseType
        )
    }
    
    /// PATCH request
    func patch<T: Decodable>(
        endpoint: String,
        body: Encodable,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .patch,
            body: body,
            headers: headers,
            responseType: responseType
        )
    }
}

// MARK: - HTTP Methods

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}
