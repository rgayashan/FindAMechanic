//
//  APIConstants.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import Foundation

enum APIConstants {
    static let config: [String: Any] = {
        guard let file = Bundle.main.path(forResource: Bundle.main.object(forInfoDictionaryKey: "APP_CONFIG") as? String, ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: file) as? [String: Any] else {
            fatalError("Missing config plist")
        }
        return dict
    }()

    static let baseURL = config["BASE_URL"] as? String ?? ""
    static let authToken = config["AUTH_TOKEN"] as? String ?? ""
}
