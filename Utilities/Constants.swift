//
//  Constants.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit

struct Constants {
    // MARK: - UI Constants
    
    struct UI {
        static let cornerRadius: CGFloat = 8.0
        static let smallPadding: CGFloat = 8.0
        static let mediumPadding: CGFloat = 16.0
        static let largePadding: CGFloat = 24.0
        
        static let buttonHeight: CGFloat = 48.0
        static let textFieldHeight: CGFloat = 44.0
        
        static let animationDuration: TimeInterval = 0.3
        
        struct Colors {
            static let primaryColor = UIColor.systemBlue
            static let secondaryColor = UIColor.systemGreen
            static let backgroundColor = UIColor.white
            static let textColor = UIColor.darkText
            static let subtitleColor = UIColor.darkGray
            static let errorColor = UIColor.systemRed
        }
        
        struct Fonts {
            static let titleFont = UIFont.boldSystemFont(ofSize: 18.0)
            static let subtitleFont = UIFont.systemFont(ofSize: 14.0)
            static let bodyFont = UIFont.systemFont(ofSize: 16.0)
            static let buttonFont = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    
    // MARK: - Validation Constants
    
    struct Validation {
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let phoneRegex = "^[0-9+]{10,15}$"
        
        struct ErrorMessages {
            static let invalidEmail = "Please enter a valid email address"
            static let invalidPhone = "Please enter a valid phone number"
            static let requiredField = "This field is required"
        }
    }
    
    // MARK: - Network Constants
    
    struct Network {
        static let baseURL = "https://findamechanic.example.com/api"
        static let timeoutInterval: TimeInterval = 30.0
        
        struct Endpoints {
            static let mechanics = "/mechanics"
            static let mechanic = "/mechanics/"
            static let inquiry = "/inquiry"
        }
    }
    
    // MARK: - Notification Names
    
    struct NotificationNames {
        static let mechanicListUpdated = Notification.Name("mechanicListUpdated")
        static let inquirySent = Notification.Name("inquirySent")
        static let userLocationUpdated = Notification.Name("userLocationUpdated")
    }
    
    // MARK: - Cell Identifiers
    
    struct CellIdentifiers {
        static let mechanicCell = "MechanicTableViewCell"
        static let serviceCell = "ServiceTableViewCell"
        static let reviewCell = "ReviewTableViewCell"
    }
}

