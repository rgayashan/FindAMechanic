//
//  MechanicDetails.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit
import MapKit
import Foundation

// MARK: - API Response Models
struct TenantResponse: Codable {
    let businessName: String?
    let phoneNumber: String?
    let fax: String?
    let licenseNumber: String?
    let email: String?
    let businessRegistrationNumber: String?
    let statusId: String?
    let logo: String?
    let lastUpdatedTime: String?
    let shpCountry: Country?
    let shpLatitude: Double?
    let shpLongitude: Double?
    let billStreetNumber: String?
    let billStreetName: String?
    let billCity: String?
    let billPostalCode: String?
    let billRegion: String?
    let billCountry: Country?
    let billLatitude: Double?
    let billLongitude: Double?
    let bannerImage: String?
    let expireStatus: Bool?
    let newUserIdentitiyStatus: Bool?
    let price: Double?
    let expiryDate: String?
    let tenantGuid: String?
    let timeEntryUOMId: String?
    let invoiceUOMId: String?
    let dateFormat: Int?
    let id: Int?
}

struct Country: Codable {
    let code: String?
}

// MARK: - Service Area Models
struct ServiceAreaResponse: Codable {
    let statusCode: Int
    let result: ServiceAreaResult
}

struct ServiceAreaResult: Codable {
    let page: Int
    let pageSize: Int
    let totalPages: Int
    let result: ServiceAreaValues
}

struct ServiceAreaValues: Codable {
    let values: [ServiceArea]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let directArray = try? container.decode([ServiceArea].self) {
            // Handle case where result is directly an array
            self.values = directArray
        } else {
            // Try decoding as an object with $values key
            let nestedContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.values = try nestedContainer.decode([ServiceArea].self, forKey: .values)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case values = "$values"
    }
}

struct ServiceArea: Codable {
    let postalCode: Int
    let cityName: String
    let id: Int
}

// MARK: - Tenant Service Models
struct TenantServiceResponse: Codable {
    let statusCode: Int
    let result: TenantServiceResult
}

struct TenantServiceResult: Codable {
    let page: Int
    let pageSize: Int
    let totalPages: Int
    let result: TenantServiceValues
}

struct TenantServiceValues: Codable {
    let values: [TenantService]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let directArray = try? container.decode([TenantService].self) {
            // Handle case where result is directly an array
            self.values = directArray
        } else {
            // Try decoding as an object with $values key
            let nestedContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.values = try nestedContainer.decode([TenantService].self, forKey: .values)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case values = "$values"
    }
}

struct TenantService: Codable {
    let description: String
    let title: String
    let id: Int
}

// MARK: - Opening Hours Models
struct OpeningHoursResponse: Codable {
    let tenantId: Int
    let monStart: String
    let monEnd: String
    let monStatus: Bool
    let tueStart: String
    let tueEnd: String
    let tueStatus: Bool
    let wedStart: String
    let wedEnd: String
    let wedStatus: Bool
    let thuStart: String
    let thuEnd: String
    let thuStatus: Bool
    let friStart: String
    let friEnd: String
    let friStatus: Bool
    let satStart: String
    let satEnd: String
    let satStatus: Bool
    let sunStart: String
    let sunEnd: String
    let sunStatus: Bool
    let weekStartDay: Int
    let id: Int
}

// MARK: - View Models
struct MechanicDetails {
    let id: String
    let name: String
    let address: String
    let phone: String
    let fax: String?
    let email: String
    let licenseNumber: String
    let businessRegistrationNumber: String
    let logo: String?
    let bannerImage: String?
    let services: [Service]
    let servicingAreas: [ServiceArea]
    let openingHours: [OpeningHour]
    let locations: [MechanicLocation]
    let price: Double
    let tenantId: Int
}

struct MechanicLocation {
    let coordinate: CLLocationCoordinate2D
    let name: String
    let address: String
}

struct Service {
    let title: String
    let description: String
}

struct OpeningHour {
    let day: String
    let status: Bool
    let startTime: String
    let endTime: String
}
