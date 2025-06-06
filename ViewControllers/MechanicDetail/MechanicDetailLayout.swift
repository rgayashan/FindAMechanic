//
//  MechanicDetailLayout.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

class MechanicDetailLayout {
    private weak var viewController: MechanicDetailViewController?
    private var sectionConstraints: [String: [NSLayoutConstraint]] = [:]
    private var contentHeightConstraint: NSLayoutConstraint?
    
    init(viewController: MechanicDetailViewController) {
        self.viewController = viewController
    }
    
    func setupScrollView(in view: UIView, scrollView: UIScrollView, contentView: UIView) {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Enable scrolling
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupContentConstraints(
        in contentView: UIView,
        headerImageView: UIImageView,
        logoImageView: UIImageView,
        nameLabel: UILabel,
        addressLabel: UILabel,
        phoneLabel: UILabel,
        servicesHeaderLabel: UILabel,
        servicesStackView: UIStackView,
        areasHeaderLabel: UILabel,
        areasStackView: UIStackView,
        hoursHeaderLabel: UILabel,
        hoursTableView: UITableView,
        locationHeaderLabel: UILabel,
        mapView: UIView
    ) {
        let padding: CGFloat = 20
        let sectionSpacing: CGFloat = 32
        let headerHeight: CGFloat = 44
        
        // Deactivate any existing constraints
        sectionConstraints.values.forEach { NSLayoutConstraint.deactivate($0) }
        sectionConstraints.removeAll()
        
        // Basic info section constraints (always visible)
        let basicInfoConstraints = [
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -40),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            phoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ]
        sectionConstraints["basicInfo"] = basicInfoConstraints
        
        // Services section constraints
        let servicesConstraints = [
            servicesHeaderLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: sectionSpacing),
            servicesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            servicesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            servicesHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            servicesStackView.topAnchor.constraint(equalTo: servicesHeaderLabel.bottomAnchor, constant: 12),
            servicesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            servicesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ]
        sectionConstraints["services"] = servicesConstraints
        
        // Areas section constraints
        let areasConstraints = [
            areasHeaderLabel.topAnchor.constraint(equalTo: servicesStackView.bottomAnchor, constant: sectionSpacing),
            areasHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            areasHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            areasHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            areasStackView.topAnchor.constraint(equalTo: areasHeaderLabel.bottomAnchor, constant: 12),
            areasStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            areasStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ]
        sectionConstraints["areas"] = areasConstraints
        
        // Hours section constraints
        let hoursConstraints = [
            hoursHeaderLabel.topAnchor.constraint(equalTo: areasStackView.bottomAnchor, constant: sectionSpacing),
            hoursHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            hoursHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            hoursHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            hoursTableView.topAnchor.constraint(equalTo: hoursHeaderLabel.bottomAnchor, constant: 12),
            hoursTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            hoursTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            hoursTableView.heightAnchor.constraint(equalToConstant: 44 * 7 + 1)
        ]
        sectionConstraints["hours"] = hoursConstraints
        
        // Location section constraints
        let locationConstraints = [
            locationHeaderLabel.topAnchor.constraint(equalTo: hoursTableView.bottomAnchor, constant: sectionSpacing),
            locationHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            locationHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            locationHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            mapView.topAnchor.constraint(equalTo: locationHeaderLabel.bottomAnchor, constant: 12),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mapView.heightAnchor.constraint(equalToConstant: 200)
        ]
        sectionConstraints["location"] = locationConstraints
        
        // Bottom constraint for the content view
        let bottomConstraint = mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        bottomConstraint.priority = .defaultHigh // Lower priority to avoid conflicts
        bottomConstraint.isActive = true
        
        // Activate all constraints initially
        NSLayoutConstraint.activate(basicInfoConstraints)
        updateSectionConstraints(
            servicesHeaderLabel: servicesHeaderLabel,
            servicesStackView: servicesStackView,
            areasHeaderLabel: areasHeaderLabel,
            areasStackView: areasStackView,
            hoursHeaderLabel: hoursHeaderLabel,
            hoursTableView: hoursTableView,
            locationHeaderLabel: locationHeaderLabel,
            mapView: mapView
        )
    }
    
    func updateSectionConstraints(
        servicesHeaderLabel: UILabel,
        servicesStackView: UIStackView,
        areasHeaderLabel: UILabel,
        areasStackView: UIStackView,
        hoursHeaderLabel: UILabel,
        hoursTableView: UITableView,
        locationHeaderLabel: UILabel,
        mapView: UIView
    ) {
        // Deactivate all section constraints first
        ["services", "areas", "hours", "location"].forEach { section in
            if let constraints = sectionConstraints[section] {
                NSLayoutConstraint.deactivate(constraints)
            }
        }
        
        // Create an array to store the visible sections in order
        var lastVisibleView: UIView = servicesHeaderLabel.superview?.viewWithTag(999) ?? servicesHeaderLabel // Using phoneLabel as fallback
        
        // Check and activate services section if visible
        if !servicesHeaderLabel.isHidden && !servicesStackView.isHidden {
            if let constraints = sectionConstraints["services"] {
                NSLayoutConstraint.activate(constraints)
                lastVisibleView = servicesStackView
            }
        }
        
        // Check and activate areas section if visible
        if !areasHeaderLabel.isHidden && !areasStackView.isHidden {
            if let constraints = sectionConstraints["areas"] {
                var updatedConstraints = constraints
                updatedConstraints[0] = areasHeaderLabel.topAnchor.constraint(equalTo: lastVisibleView.bottomAnchor, constant: 32)
                NSLayoutConstraint.activate(updatedConstraints)
                lastVisibleView = areasStackView
            }
        }
        
        // Check and activate hours section if visible
        if !hoursHeaderLabel.isHidden && !hoursTableView.isHidden {
            if let constraints = sectionConstraints["hours"] {
                var updatedConstraints = constraints
                updatedConstraints[0] = hoursHeaderLabel.topAnchor.constraint(equalTo: lastVisibleView.bottomAnchor, constant: 32)
                NSLayoutConstraint.activate(updatedConstraints)
                lastVisibleView = hoursTableView
            }
        }
        
        // Check and activate location section if visible
        if !locationHeaderLabel.isHidden && !mapView.isHidden {
            if let constraints = sectionConstraints["location"] {
                var updatedConstraints = constraints
                updatedConstraints[0] = locationHeaderLabel.topAnchor.constraint(equalTo: lastVisibleView.bottomAnchor, constant: 32)
                NSLayoutConstraint.activate(updatedConstraints)
            }
        }
        
        // Force layout update
        lastVisibleView.superview?.layoutIfNeeded()
    }
    
    // Helper function for determining max Y anchor
    func max(_ lhs: NSLayoutYAxisAnchor, _ rhs: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
        return rhs // A simplification - in practice would need a more complex solution
    }
} 
