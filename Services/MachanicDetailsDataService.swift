//
//  MachanicDetailsDataService.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//


import Foundation
import MapKit

enum DataServiceError: LocalizedError {
    case networkError(String)
    case decodingError(String)
    case notFound(String)
    case invalidResponse(String)
    case invalidData(String)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let details):
            return "Network connection error: \(details)"
        case .decodingError(let details):
            return "Error processing data: \(details)"
        case .notFound(let details):
            return "Resource not found: \(details)"
        case .invalidResponse(let details):
            return "Invalid response: \(details)"
        case .invalidData(let details):
            return "Invalid data: \(details)"
        case .unknown(let details):
            return "An unknown error occurred: \(details)"
        }
    }
}

class MachanicDetailsDataService {
    // Singleton instance
    static let shared = MachanicDetailsDataService()
    
    private let baseURL = APIConstants.baseURL
    private let authToken = APIConstants.authToken
    
    private init() {}
    
    // MARK: - Helper Methods
    private func createRequest(for endpoint: String) -> URLRequest {
        let url = URL(string: "\(baseURL)/\(endpoint)")!
        var request = URLRequest(url: url)
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    private func validateResponse(_ response: URLResponse, for endpoint: String) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw DataServiceError.invalidResponse("Non-HTTP response received for \(endpoint)")
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw DataServiceError.networkError("Unauthorized access. Please check your authentication token.")
        case 403:
            throw DataServiceError.networkError("Access forbidden. You don't have permission to access this resource.")
        case 404:
            throw DataServiceError.notFound("Resource not found at endpoint: \(endpoint)")
        case 500...599:
            throw DataServiceError.networkError("Server error occurred (Status: \(httpResponse.statusCode))")
        default:
            throw DataServiceError.networkError("Unexpected status code: \(httpResponse.statusCode)")
        }
    }
    
    private func decode<T: Decodable>(_ data: Data, as type: T.Type = T.self) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try decoder.decode(type, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            throw DataServiceError.decodingError("Missing key '\(key.stringValue)' - \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(type, context) {
            throw DataServiceError.decodingError("Missing value of type '\(type)' - \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            throw DataServiceError.decodingError("Type mismatch for type '\(type)' - \(context.debugDescription)")
        } catch let DecodingError.dataCorrupted(context) {
            throw DataServiceError.decodingError("Data corrupted - \(context.debugDescription)")
        } catch {
            throw DataServiceError.decodingError("Unknown decoding error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - API Calls
    private func fetchTenantDetails(_ tenantId: String) async throws -> TenantResponse {
        let endpoint = "api/tenants/\(tenantId)"
        let request = createRequest(for: endpoint)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try validateResponse(response, for: endpoint)
            
            guard !data.isEmpty else {
                throw DataServiceError.invalidData("Empty response received for tenant details")
            }
            
            print("Tenant details response for ID \(tenantId): \(String(data: data, encoding: .utf8) ?? "")")
            return try decode(data)
        } catch let error as DataServiceError {
            throw error
        } catch {
            throw DataServiceError.unknown("Failed to fetch tenant details: \(error.localizedDescription)")
        }
    }
    
    private func fetchServiceAreas(_ tenantId: String) async throws -> [ServiceArea] {
        let endpoint = "api/tenants/serviceAreas/\(tenantId)"
        let request = createRequest(for: endpoint)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try validateResponse(response, for: endpoint)
            
            guard !data.isEmpty else {
                throw DataServiceError.invalidData("Empty response received for service areas")
            }
            
            let serviceAreaResponse: ServiceAreaResponse = try decode(data)
            print("ServiceAreaResponse \(serviceAreaResponse)")
            return serviceAreaResponse.result.result.values
        } catch let error as DataServiceError {
            throw error
        } catch {
            throw DataServiceError.unknown("Failed to fetch service areas: \(error.localizedDescription)")
        }
    }
    
    private func fetchServices(_ tenantId: String) async throws -> [TenantService] {
        let endpoint = "api/tenants/services/\(tenantId)"
        let request = createRequest(for: endpoint)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try validateResponse(response, for: endpoint)
            
            guard !data.isEmpty else {
                throw DataServiceError.invalidData("Empty response received for services")
            }
            
            let servicesResponse: TenantServiceResponse = try decode(data)
            print("servicesResponse \(servicesResponse)")
            return servicesResponse.result.result.values
        } catch let error as DataServiceError {
            throw error
        } catch {
            throw DataServiceError.unknown("Failed to fetch services: \(error.localizedDescription)")
        }
    }
    
    private func fetchOpeningHours(_ tenantId: String) async throws -> OpeningHoursResponse {
        let endpoint = "api/tenants/openingHours/\(tenantId)"
        let request = createRequest(for: endpoint)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try validateResponse(response, for: endpoint)
            
            guard !data.isEmpty else {
                throw DataServiceError.invalidData("Empty response received for opening hours")
            }
            
            let openingHoursResponse: OpeningHoursResponse = try decode(data)
            print("OpeningHoursResponse \(openingHoursResponse)")
            return openingHoursResponse
        } catch let error as DataServiceError {
            throw error
        } catch {
            throw DataServiceError.unknown("Failed to fetch opening hours: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Public Methods
    func getMechanicDetails(mechanicID: String, completion: @escaping (Result<MechanicDetails, Error>) -> Void) {
        print("Fetching details for mechanic ID: \(mechanicID)")
        Task {
            do {
                async let tenantResponse = fetchTenantDetails(mechanicID)
                async let serviceAreas = fetchServiceAreas(mechanicID)
                async let services = fetchServices(mechanicID)
                async let hoursResponse = fetchOpeningHours(mechanicID)
                
                let (tenant, areas, tenantServices, hours) = try await (tenantResponse, serviceAreas, services, hoursResponse)
                print("Successfully fetched all data for mechanic ID: \(mechanicID)")
                
                // Create formatted address
                let address = [
                    "\(tenant.billStreetNumber ?? ""), \(tenant.billStreetName ?? "")",
                    "\(tenant.billCity ?? ""), \(tenant.billPostalCode ?? "")",
                    tenant.billRegion ?? "",
                    tenant.billCountry?.code ?? ""
                ].filter { !$0.isEmpty && $0 != ", " }
                 .joined(separator: "\n")
                
                // Convert services
                let formattedServices = tenantServices.map { Service(title: $0.title, description: $0.description) }
                
                // Create opening hours
                let formattedHours = [
                    OpeningHour(day: "Monday", status: hours.monStatus, startTime: hours.monStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: hours.monEnd.replacingOccurrences(of: ":00:00", with: ":00")),
                    OpeningHour(day: "Tuesday", status: hours.tueStatus, startTime: hours.tueStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: hours.tueEnd.replacingOccurrences(of: ":00:00", with: ":00")),
                    OpeningHour(day: "Wednesday", status: hours.wedStatus, startTime: hours.wedStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: hours.wedEnd.replacingOccurrences(of: ":00:00", with: ":00")),
                    OpeningHour(day: "Thursday", status: hours.thuStatus, startTime: hours.thuStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: hours.thuEnd.replacingOccurrences(of: ":00:00", with: ":00")),
                    OpeningHour(day: "Friday", status: hours.friStatus, startTime: hours.friStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: hours.friEnd.replacingOccurrences(of: ":00:00", with: ":00")),
                    OpeningHour(day: "Saturday", status: hours.satStatus, startTime: hours.satStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: hours.satEnd.replacingOccurrences(of: ":00:00", with: ":00")),
                    OpeningHour(day: "Sunday", status: hours.sunStatus, startTime: hours.sunStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: hours.sunEnd.replacingOccurrences(of: ":00:00", with: ":00"))
                ]
                
                print("Debug - First opening hour: \(formattedHours[0])")
                
                // Create location only if valid coordinates exist
                var locations: [MechanicLocation] = []
                if let latitude = tenant.billLatitude,
                   let longitude = tenant.billLongitude,
                   latitude != 0 || longitude != 0 {
                    let location = MechanicLocation(
                        coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        name: tenant.businessName ?? "",
                        address: address
                    )
                    locations.append(location)
                }
                
                let mechanicDetails = MechanicDetails(
                    id: String(tenant.id ?? 0),
                    name: tenant.businessName ?? "",
                    address: address,
                    phone: tenant.phoneNumber ?? "",
                    fax: tenant.fax ?? "",
                    email: tenant.email ?? "",
                    licenseNumber: tenant.licenseNumber ?? "",
                    businessRegistrationNumber: tenant.businessRegistrationNumber ?? "",
                    logo: tenant.logo,
                    bannerImage: tenant.bannerImage,
                    services: formattedServices,
                    servicingAreas: areas,
                    openingHours: formattedHours,
                    locations: locations,
                    price: tenant.price ?? 0
                )
                
                DispatchQueue.main.async {
                    completion(.success(mechanicDetails))
                }
            } catch {
                let errorMessage: String
                if let dataError = error as? DataServiceError {
                    errorMessage = dataError.errorDescription ?? "Unknown error occurred"
                } else {
                    errorMessage = error.localizedDescription
                }
                
                print("Get Mechanic Details Error: \(errorMessage)")
                DispatchQueue.main.async {
                    completion(.failure(DataServiceError.unknown(errorMessage)))
                }
            }
        }
    }
    
    // MARK: - Mechanics List
    func getMechanicsList(location: CLLocationCoordinate2D?, completion: @escaping (Result<[MechanicDetails], Error>) -> Void) {
        let endpoint = "api/Tenants"
        let request = createRequest(for: endpoint)
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                try validateResponse(response, for: endpoint)
                
                guard !data.isEmpty else {
                    throw DataServiceError.invalidData("Empty response received for mechanics list")
                }
                
                let apiResponse = try decode(data, as: APIResponse.self)
                let mechanics = apiResponse.result.result.map { tenant in
                    // Create formatted address
                    let address = [
                        "\(tenant.billStreetNumber ?? ""), \(tenant.billStreetName ?? "")",
                        "\(tenant.billCity ?? ""), \(tenant.billPostalCode ?? "")",
                        tenant.billRegion ?? "",
                        tenant.billCountry?.code ?? ""
                    ].filter { !$0.isEmpty && $0 != ", " }
                     .joined(separator: "\n")
                    
                    // Create location only if valid coordinates exist
                    var locations: [MechanicLocation] = []
                    if tenant.billLatitude != 0 || tenant.billLongitude != 0 {
                        let location = MechanicLocation(
                            coordinate: CLLocationCoordinate2D(latitude: tenant.billLatitude, longitude: tenant.billLongitude),
                            name: tenant.businessName,
                            address: address
                        )
                        locations.append(location)
                    }
                    
                    return MechanicDetails(
                        id: String(tenant.id),
                        name: tenant.businessName,
                        address: address,
                        phone: tenant.phoneNumber,
                        fax: "",
                        email: tenant.phoneNumber, // Using phone as email since it's not in the API response
                        licenseNumber: "N/A",
                        businessRegistrationNumber: "N/A",
                        logo: tenant.logo,
                        bannerImage: tenant.bannerImage,
                        services: [],
                        servicingAreas: [],
                        openingHours: [],
                        locations: locations,
                        price: 0.0
                    )
                }
                
                DispatchQueue.main.async {
                    completion(.success(mechanics))
                }
            } catch {
                let errorMessage: String
                if let dataError = error as? DataServiceError {
                    errorMessage = dataError.errorDescription ?? "Unknown error occurred"
                } else {
                    errorMessage = error.localizedDescription
                }
                
                print("Get Mechanics List Error: \(errorMessage)")
                DispatchQueue.main.async {
                    completion(.failure(DataServiceError.unknown(errorMessage)))
                }
            }
        }
    }
    
    // MARK: - Book Appointment
    func bookAppointment(mechanicID: String, date: Date, service: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // This would send an appointment booking request to the server
        DispatchQueue.global().async {
            // Simulate success
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }
    }
    
    // MARK: - Send Inquiry
    func sendInquiry(mechanicID: String, message: String, contactInfo: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // This would send an inquiry to the mechanic
        DispatchQueue.global().async {
            // Simulate success
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }
    }
}
