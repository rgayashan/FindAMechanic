//
//  MachanicListDataService.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import Foundation

enum DataError: Error {
    case networkError
    case decodingError
    case noData
    case apiError(String)
}

// API Response Models
struct APIResponse: Codable {
    let statusCode: Int
    let result: PagedResponseWrapper
}

struct PagedResponseWrapper: Codable {
    let type: String
    let page: Int
    let pageSize: Int
    let totalPages: Int
    let result: [TenantResponse]
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case page
        case pageSize
        case totalPages
        case result
    }
}

struct TenantResponse: Codable {
    let businessName: String
    let phoneNumber: String
    let logo: String?
    let billStreetNumber: String?
    let billStreetName: String?
    let billCity: String?
    let billPostalCode: String?
    let billRegion: String?
    let billCountry: Country?
    let billLatitude: Double
    let billLongitude: Double
    let id: Int
}

struct Country: Codable {
    let code: String?
}

class MachanicListDataService {
    static let shared = MachanicListDataService()
    private let baseURL = APIConstants.baseURL
    private let authToken = APIConstants.authToken
    
    private init() {}
    
    func getMechanics(page: Int, itemsPerPage: Int, search: String = "", completion: @escaping (Result<[Mechanic], DataError>) -> Void) {
        let endpoint = "api/Tenants"
        let queryItems = [
            URLQueryItem(name: "Search", value: search),
            URLQueryItem(name: "pageSize", value: "\(itemsPerPage)"),
            URLQueryItem(name: "PageNumber", value: "\(page)")
        ]
        
        guard var urlComponents = URLComponents(string: "\(baseURL)/\(endpoint)") else {
            completion(.failure(.networkError))
            return
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(.networkError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                print("apiResponse \(apiResponse)")
                let mechanics = apiResponse.result.result.map { tenant in
                    let addressLine1 = [tenant.billStreetNumber, tenant.billStreetName]
                        .compactMap { $0 }
                        .joined(separator: ", ")
                    
                    let addressLine2 = [tenant.billCity, tenant.billPostalCode, tenant.billRegion]
                        .compactMap { $0 }
                        .joined(separator: ", ")
                    
                    return Mechanic(
                        id: String(tenant.id),
                        name: tenant.businessName,
                        addressLine1: addressLine1.isEmpty ? "Address not available" : addressLine1,
                        addressLine2: addressLine2.isEmpty ? "" : addressLine2,
                        phone: tenant.phoneNumber,
                        logoUrl: tenant.logo,
                        latitude: tenant.billLatitude,
                        longitude: tenant.billLongitude,
                        specialties: [], // API doesn't provide specialties
                        rating: 0.0 // API doesn't provide rating
                    )
                }
                completion(.success(mechanics))
            } catch {
                print("Decoding error: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found: \(context.debugDescription)")
                    case .typeMismatch(let type, let context):
                        print("Type '\(type)' mismatch: \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("Value of type '\(type)' not found: \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                    @unknown default:
                        print("Unknown decoding error: \(decodingError)")
                    }
                }
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
