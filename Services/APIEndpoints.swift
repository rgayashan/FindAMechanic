import Foundation

enum APIEndpoints {
    // MARK: - Base URL
    static let baseURL = APIConstants.baseURL
    
    // MARK: - Tenants
    enum Tenants {
        static let mechanicsList = "api/Tenants" // Endpoint for getting list of mechanics
        static func details(_ tenantId: String) -> String {
            return "api/tenants/\(tenantId)"
        }
        static func serviceAreas(_ tenantId: String) -> String {
            return "api/tenants/serviceAreas/\(tenantId)"
        }
        static func services(_ tenantId: String) -> String {
            return "api/tenants/services/\(tenantId)"
        }
        static func openingHours(_ tenantId: String) -> String {
            return "api/tenants/openingHours/\(tenantId)"
        }
    }
    
    // MARK: - Bookings
    enum Bookings {
        static let create = "api/bookings"
    }
    
    // MARK: - Query Parameters
    enum QueryParameters {
        static let search = "Search"
        static let pageSize = "pageSize"
        static let pageNumber = "PageNumber"
    }
    
    // MARK: - HTTP Headers
    enum Headers {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
        static let accept = "Accept"
        
        static let jsonContentType = "application/json"
    }
} 
