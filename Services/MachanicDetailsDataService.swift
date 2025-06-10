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
    private let apiService = APIService.shared
    
    private init() {}
    
    // MARK: - API Calls
    private func fetchTenantDetails(_ tenantId: String) async throws -> TenantResponse {
        return try await apiService.get(endpoint: APIEndpoints.Tenants.details(tenantId))
    }
    
    private func fetchServiceAreas(_ tenantId: String) async throws -> [ServiceArea] {
        let response: ServiceAreaResponse = try await apiService.get(endpoint: APIEndpoints.Tenants.serviceAreas(tenantId))
        return response.result.result.values
    }
    
    private func fetchServices(_ tenantId: String) async throws -> [TenantService] {
        let response: TenantServiceResponse = try await apiService.get(endpoint: APIEndpoints.Tenants.services(tenantId))
        return response.result.result.values
    }
    
    private func fetchOpeningHours(_ tenantId: String) async throws -> OpeningHoursResponse {
        return try await apiService.get(endpoint: APIEndpoints.Tenants.openingHours(tenantId))
    }
    
    // MARK: - Public Methods
    func getMechanicDetails(tenantId: String, completion: @escaping (Result<MechanicDetails, Error>) -> Void) {
        Task {
            do {
                let tenantDetails = try await fetchTenantDetails(tenantId)
                let serviceAreas = try await fetchServiceAreas(tenantId)
                let services = try await fetchServices(tenantId)
                let openingHours = try await fetchOpeningHours(tenantId)
                
                let mechanicDetails = MechanicDetails(
                    id: String(tenantDetails.id ?? 0),
                    name: tenantDetails.businessName ?? "",
                    address: formatAddress(from: tenantDetails),
                    phone: tenantDetails.phoneNumber ?? "",
                    fax: tenantDetails.fax ?? "",
                    email: tenantDetails.email ?? "",
                    licenseNumber: tenantDetails.licenseNumber ?? "",
                    businessRegistrationNumber: tenantDetails.businessRegistrationNumber ?? "",
                    logo: tenantDetails.logo,
                    bannerImage: tenantDetails.bannerImage,
                    services: services.map { Service(title: $0.title, description: $0.description) },
                    servicingAreas: serviceAreas.map { ServiceArea(postalCode: $0.postalCode, cityName: $0.cityName, id: $0.id) },
                    openingHours: formatOpeningHours(openingHours),
                    locations: createLocations(from: tenantDetails),
                    price: tenantDetails.price ?? 0.0,
                    tenantId: tenantDetails.id ?? 0
                )
                
                DispatchQueue.main.async {
                    completion(.success(mechanicDetails))
                }
            } catch {
                let errorMessage: String
                if let apiError = error as? APIError {
                    errorMessage = apiError.localizedDescription
                } else {
                    errorMessage = error.localizedDescription
                }
                DispatchQueue.main.async {
                    completion(.failure(DataServiceError.unknown(errorMessage)))
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func formatAddress(from tenant: TenantResponse) -> String {
        let addressComponents = [
            tenant.billStreetNumber,
            tenant.billStreetName,
            tenant.billCity,
            tenant.billPostalCode,
            tenant.billRegion,
            tenant.billCountry?.code
        ].compactMap { $0 }
        
        return addressComponents.joined(separator: ", ")
    }
    
    private func formatOpeningHours(_ response: OpeningHoursResponse) -> [OpeningHour] {
        return [
            OpeningHour(day: "Monday", status: response.monStatus, startTime: response.monStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: response.monEnd.replacingOccurrences(of: ":00:00", with: ":00")),
            OpeningHour(day: "Tuesday", status: response.tueStatus, startTime: response.tueStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: response.tueEnd.replacingOccurrences(of: ":00:00", with: ":00")),
            OpeningHour(day: "Wednesday", status: response.wedStatus, startTime: response.wedStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: response.wedEnd.replacingOccurrences(of: ":00:00", with: ":00")),
            OpeningHour(day: "Thursday", status: response.thuStatus, startTime: response.thuStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: response.thuEnd.replacingOccurrences(of: ":00:00", with: ":00")),
            OpeningHour(day: "Friday", status: response.friStatus, startTime: response.friStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: response.friEnd.replacingOccurrences(of: ":00:00", with: ":00")),
            OpeningHour(day: "Saturday", status: response.satStatus, startTime: response.satStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: response.satEnd.replacingOccurrences(of: ":00:00", with: ":00")),
            OpeningHour(day: "Sunday", status: response.sunStatus, startTime: response.sunStart.replacingOccurrences(of: ":00:00", with: ":00"), endTime: response.sunEnd.replacingOccurrences(of: ":00:00", with: ":00"))
        ]
    }
    
    private func createLocations(from tenant: TenantResponse) -> [MechanicLocation] {
        var locations: [MechanicLocation] = []
        
        if let latitude = tenant.billLatitude,
           let longitude = tenant.billLongitude {
            let location = MechanicLocation(
                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                name: tenant.businessName ?? "",
                address: formatAddress(from: tenant)
            )
            locations.append(location)
        }
        
        return locations
    }
    
    // MARK: - Mechanics List
    func getMechanicsList(location: CLLocationCoordinate2D?, completion: @escaping (Result<[MechanicDetails], Error>) -> Void) {
        Task {
            do {
                let apiResponse: APIResponse = try await apiService.get(endpoint: APIEndpoints.Tenants.mechanicsList)
                
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
                        price: 0.0,
                        tenantId: tenant.id
                    )
                }
                
                DispatchQueue.main.async {
                    completion(.success(mechanics))
                }
            } catch {
                let errorMessage: String
                if let apiError = error as? APIError {
                    errorMessage = apiError.localizedDescription
                } else {
                    errorMessage = error.localizedDescription
                }
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
