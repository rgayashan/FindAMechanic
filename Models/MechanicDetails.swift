//
//  MechanicDetails.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit
import MapKit
import Foundation

struct MechanicDetails {
    let id: String
    let name: String
    let address: String
    let phone: String
    let logo: String?
    let headerImage: String?
    let services: [Service]
    let servicingAreas: [String]
    let openingHours: [OpeningHour]
    let locations: [MechanicLocation]
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
    let status: String
    let startTime: String
    let endTime: String
}
