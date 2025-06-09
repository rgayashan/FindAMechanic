import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    case unauthorized
    case notFound
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Error decoding response: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .unauthorized:
            return "Unauthorized access"
        case .notFound:
            return "Resource not found"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

class APIService {
    static let shared = APIService()
    private let baseURL = APIEndpoints.baseURL
    private let authToken = APIConstants.authToken
    
    private init() {}
    
    // MARK: - Common Request Creation
    private func createRequest(for endpoint: String, method: String = "GET", body: Data? = nil) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue(authToken, forHTTPHeaderField: APIEndpoints.Headers.authorization)
        request.addValue(APIEndpoints.Headers.jsonContentType, forHTTPHeaderField: APIEndpoints.Headers.accept)
        
        if method != "GET" {
            request.addValue(APIEndpoints.Headers.jsonContentType, forHTTPHeaderField: APIEndpoints.Headers.contentType)
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    // MARK: - Common Response Validation
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw APIError.unauthorized
        case 404:
            throw APIError.notFound
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.serverError(httpResponse.statusCode)
        }
    }
    
    // MARK: - GET Request
    func get<T: Decodable>(endpoint: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        guard var urlComponents = URLComponents(string: "\(baseURL)/\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        urlComponents.queryItems = queryItems
        
        guard let _ = urlComponents.url,
              let request = createRequest(for: endpoint) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try validateResponse(response)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.unknown(error)
        }
    }
    
    // MARK: - POST Request
    func post<T: Decodable>(endpoint: String, body: [String: Any]) async throws -> T {
        guard var request = createRequest(for: endpoint, method: "POST") else {
            throw APIError.invalidURL
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            try validateResponse(response)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.unknown(error)
        }
    }
} 
