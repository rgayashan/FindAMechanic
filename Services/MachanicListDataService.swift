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
    let result: [TenantListResponse]
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case page
        case pageSize
        case totalPages
        case result
    }
}

struct TenantListResponse: Codable {
    let businessName: String
    let phoneNumber: String
    let logo: String?
    let bannerImage: String?
    let billStreetNumber: String?
    let billStreetName: String?
    let billCity: String?
    let billPostalCode: String?
    let billRegion: String?
    let billCountry: CountryList?
    let billLatitude: Double
    let billLongitude: Double
    let id: Int
}

struct CountryList: Codable {
    let code: String?
}

class MachanicListDataService {
    static let shared = MachanicListDataService()
    private let apiService = APIService.shared
    
    private init() {}
    
    func getMechanics(page: Int, itemsPerPage: Int, search: String = "", completion: @escaping (Result<[Mechanic], DataError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: APIEndpoints.QueryParameters.search, value: search),
            URLQueryItem(name: APIEndpoints.QueryParameters.pageSize, value: "\(itemsPerPage)"),
            URLQueryItem(name: APIEndpoints.QueryParameters.pageNumber, value: "\(page)")
        ]
        
        Task {
            do {
                let apiResponse: APIResponse = try await apiService.get(
                    endpoint: APIEndpoints.Tenants.mechanicsList,
                    queryItems: queryItems
                )
                
                let mechanics = apiResponse.result.result.map { tenant in
                    let addressLine1 = [tenant.billStreetNumber, tenant.billStreetName]
                        .compactMap { $0?.isEmpty ?? true ? nil : $0 }
                        .joined(separator: ", ")
                    
                    let addressLine2 = [tenant.billCity, tenant.billPostalCode, tenant.billRegion]
                        .compactMap { $0?.isEmpty ?? true ? nil : $0 }
                        .joined(separator: ", ")
                    
                    return Mechanic(
                        id: String(tenant.id),
                        name: tenant.businessName,
                        addressLine1: addressLine1.isEmpty ? "Address not available" : addressLine1,
                        addressLine2: addressLine2.isEmpty ? "" : addressLine2,
                        phone: tenant.phoneNumber,
                        logoUrl: tenant.logo,
                        bannerImage: tenant.bannerImage,
                        latitude: tenant.billLatitude,
                        longitude: tenant.billLongitude,
                        specialties: [], // API doesn't provide specialties
                        rating: 0.0 // API doesn't provide rating
                    )
                }
                
                DispatchQueue.main.async {
                    completion(.success(mechanics))
                }
            } catch {

                let dataError: DataError
                if let apiError = error as? APIError {
                    dataError = .apiError(apiError.localizedDescription)
                } else {
                    dataError = .networkError
                }
                DispatchQueue.main.async {
                    completion(.failure(dataError))
                }
            }
        }
    }
}
