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
}

class MachanicListDataService {
    static let shared = MachanicListDataService()
    
    private init() {}
    
    // For demo purposes, this generates mock data
    // In a real app, you would make API calls here
    func getMechanics(page: Int, itemsPerPage: Int, completion: @escaping (Result<[Mechanic], DataError>) -> Void) {
        // Sample mechanics data - in a real app, this would come from an API
        let sampleMechanics = [
            Mechanic(id: "1", name: "Dhana Auto Care Pty Ltd",
                    addressLine1: "2, Talara",
                    addressLine2: "Mango Hill, 4509, QLD",
                    phone: "+61 481 331 800",
                    logoUrl: "https://picsum.photos/200/300",
                    latitude: -27.2340,
                    longitude: 153.0234,
                    specialties: ["General Repairs", "Electrical"],
                    rating: 4.7),
            
            Mechanic(id: "2", name: "Albert's Auto Electrical",
                    addressLine1: "3/41, O'Connell Street",
                    addressLine2: "Smithfield, 2164, NSW",
                    phone: "+61 421 667 118",
                    logoUrl: "https://picsum.photos/200/300",
                    latitude: -33.8442,
                    longitude: 150.9431,
                    specialties: ["Electrical", "Diagnostics"],
                    rating: 4.5),
                    
            Mechanic(id: "3", name: "Western Pit Stop Automotive Pty Ltd",
                    addressLine1: "10/11, Bowmans Road",
                    addressLine2: "Kings Park, 2148, NSW",
                    phone: "02 967 6 8 589",
                    logoUrl: "https://picsum.photos/200/300",
                    latitude: -33.7442,
                    longitude: 150.9131,
                    specialties: ["General Service", "Brakes", "Suspension"],
                    rating: 4.2),
                    
            Mechanic(id: "4", name: "Grease Monkey Automotive",
                    addressLine1: "7 398, Marion st",
                    addressLine2: "Condell Park, 2200, NSW",
                    phone: "+61 297 961 616",
                    logoUrl: nil,
                    latitude: -33.9242,
                    longitude: 151.0131,
                    specialties: ["Engine Repair", "Transmissions"],
                    rating: 4.8)
        ]
        
        // Calculate the starting and ending indices for the requested page
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, sampleMechanics.count)
        
        // Check if start index is valid
        guard startIndex < sampleMechanics.count else {
            completion(.success([]))
            return
        }
        
        // Get the requested subset of mechanics
        let pageMechanics = Array(sampleMechanics[startIndex..<endIndex])
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(pageMechanics))
        }
    }
}
