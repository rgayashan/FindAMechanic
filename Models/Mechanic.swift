//
//  Mechanic.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import Foundation

struct Mechanic: Codable {
    let id: String
    let name: String
    let addressLine1: String
    let addressLine2: String
    let phone: String
    let logoUrl: String?
    let latitude: Double?
    let longitude: Double?
    let specialties: [String]?
    let rating: Double?
}
