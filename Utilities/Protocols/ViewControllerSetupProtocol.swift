//
//  ViewControllerSetupProtocol.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit

/// Protocol that defines standard methods for setting up view controllers
protocol ViewControllerSetupProtocol: AnyObject {
    /// Configure UI components
    func setupUI()
    
    /// Configure layout constraints
    func setupConstraints()
    
    /// Configure delegates
    func setupDelegates()
    
    /// Add subviews to the view hierarchy
    func addSubviews()
    
    /// Configure any additional behaviors or listeners
    func setupAdditionalConfigurations()
}

extension ViewControllerSetupProtocol {
    /// Default complete setup method that calls all setup methods in the correct order
    func performSetup() {
        addSubviews()
        setupUI()
        setupConstraints()
        setupDelegates()
        setupAdditionalConfigurations()
    }
    
    /// Default implementation for additional configurations
    func setupAdditionalConfigurations() {
        // Optional default implementation
    }
} 
