//
//  MachanicListDataService.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//


import Foundation
import MapKit

enum DataServiceError: Error {
    case networkError
    case decodingError
    case notFound
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Network connection error. Please check your internet connection."
        case .decodingError:
            return "Error processing data from the server."
        case .notFound:
            return "The requested mechanic could not be found."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

class MachanicDetailsDataService {
    // Singleton instance
    static let shared = MachanicDetailsDataService()
    
    private init() {}
    
    // MARK: - Mechanic Details
    func getMechanicDetails(mechanicID: String, completion: @escaping (Result<MechanicDetails, Error>) -> Void) {
        // In a real app, this would make a network request to fetch mechanic details
        // For demonstration, we'll use mock data
        
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            // Create mock data based on screenshots
            let mockMechanic = MechanicDetails(
                id: mechanicID,
                name: "Western Pit Stop Automotive Pty Ltd",
                address: "10/11, Bowmans Road\nKings Park, 2148, NSW",
                phone: "02 967 6 8 589",
                logo: "https://picsum.photos/200/300",
                headerImage: "https://picsum.photos/200/300",
                services: [
                    Service(title: "Log Book Service", description: "We provide our customers with the ability to service their brand new cars without affecting the seller's statutory warranty obligations. All services are carried out according to the manufacturer stipulated schedule and specifications."),
                    Service(title: "eSafety Check & Inspection", description: "If you want to renew your vehicle registration and your vehicle is more than 5 years old, you will need a Safety Check. Safety checks are basic mechanical checks, targeting certain vehicle components that may cause a risk to drivers and passengers."),
                    Service(title: "Repairs", description: "We provide a friendly, expert car repair service by fully qualified technicians. We do all routine and maintenance repairs and major parts replacement services for all makes and models of cars."),
                    Service(title: "Services", description: "It is important to service your car regularly to ensure your safety and reliable motoring. Your safety and reliable motoring is our priority. We carry out 40 points safety check.")
                ],
                servicingAreas: [
                    "Baulkham Hills, 2153",
                    "Bella Vista, 2153",
                    "Blacktown, 2148",
                    "Carlingford, 2118",
                    "Castle Hill, 2154",
                    "Cherrybrook, 2126",
                    "Eastwood, 2122",
                    "Glenwood, 2768"
                ],
                openingHours: [
                    OpeningHour(day: "Monday", status: "Open", startTime: "08:00:00", endTime: "17:00:00"),
                    OpeningHour(day: "Tuesday", status: "Open", startTime: "08:00:00", endTime: "17:00:00"),
                    OpeningHour(day: "Wednesday", status: "Open", startTime: "08:00:00", endTime: "17:00:00"),
                    OpeningHour(day: "Thursday", status: "Open", startTime: "08:00:00", endTime: "17:00:00"),
                    OpeningHour(day: "Friday", status: "Open", startTime: "08:00:00", endTime: "17:00:00"),
                    OpeningHour(day: "Saturday", status: "Open", startTime: "08:00:00", endTime: "14:00:00"),
                    OpeningHour(day: "Sunday", status: "Closed", startTime: "", endTime: "")
                ],
                locations: [
                            MechanicLocation(
                                coordinate: CLLocationCoordinate2D(latitude: -33.7439, longitude: 150.9139),
                                name: "Kings Park Location",
                                address: "10/11, Bowmans Road, Kings Park, 2148, NSW"
                            ),
                            MechanicLocation(
                                coordinate: CLLocationCoordinate2D(latitude: -33.7620, longitude: 150.9220),
                                name: "Blacktown Location",
                                address: "25 Main Street, Blacktown, 2148, NSW"
                            ),
                            MechanicLocation(
                                coordinate: CLLocationCoordinate2D(latitude: -33.7780, longitude: 150.9330),
                                name: "Seven Hills Location",
                                address: "102 Prospect Highway, Seven Hills, 2147, NSW"
                            )
                        ]
            )
            
            completion(.success(mockMechanic))
        }
    }
    
    // MARK: - Mechanics List
    func getMechanicsList(location: CLLocationCoordinate2D?, completion: @escaping (Result<[MechanicDetails], Error>) -> Void) {
        // This would fetch a list of mechanics, possibly filtered by location
        // For now, it returns a single item array with our mock mechanic
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let mockMechanic = MechanicDetails(
                id: "1",
                name: "Western Pit Stop Automotive Pty Ltd",
                address: "10/11, Bowmans Road\nKings Park, 2148, NSW",
                phone: "02 967 6 8 589",
                logo: "https://picsum.photos/200/300",
                headerImage: nil,
                services: [],
                servicingAreas: [],
                openingHours: [],
                locations: [
                            MechanicLocation(
                                coordinate: CLLocationCoordinate2D(latitude: -33.7439, longitude: 150.9139),
                                name: "Kings Park Location",
                                address: "10/11, Bowmans Road, Kings Park, 2148, NSW"
                            ),
                            MechanicLocation(
                                coordinate: CLLocationCoordinate2D(latitude: -33.7620, longitude: 150.9220),
                                name: "Blacktown Location",
                                address: "25 Main Street, Blacktown, 2148, NSW"
                            ),
                            MechanicLocation(
                                coordinate: CLLocationCoordinate2D(latitude: -33.7780, longitude: 150.9330),
                                name: "Seven Hills Location",
                                address: "102 Prospect Highway, Seven Hills, 2147, NSW"
                            )
                        ]
            )
            
            completion(.success([mockMechanic]))
        }
    }
    
    // MARK: - Book Appointment
    func bookAppointment(mechanicID: String, date: Date, service: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // This would send an appointment booking request to the server
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            // Simulate success
            completion(.success(true))
        }
    }
    
    // MARK: - Send Inquiry
    func sendInquiry(mechanicID: String, message: String, contactInfo: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // This would send an inquiry to the mechanic
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            // Simulate success
            completion(.success(true))
        }
    }
}
