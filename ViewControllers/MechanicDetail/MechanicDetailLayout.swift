//
//  MechanicDetailLayout.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

class MechanicDetailLayout {
    private weak var viewController: MechanicDetailViewController?
    
    init(viewController: MechanicDetailViewController) {
        self.viewController = viewController
    }
    
    func setupScrollView(in view: UIView, scrollView: UIScrollView, contentView: UIView) {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
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
        let padding: CGFloat = 20 // Increased padding
        let sectionSpacing: CGFloat = 32 // Increased section spacing
        let headerHeight: CGFloat = 44 // Slightly increased header height
        
        // Store constraints that need to be updated when sections are hidden
        var constraints: [NSLayoutConstraint] = []
        
        // Header and basic info constraints
        constraints += [
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
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Services section
            servicesHeaderLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: sectionSpacing),
            servicesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            servicesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            servicesHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            servicesStackView.topAnchor.constraint(equalTo: servicesHeaderLabel.bottomAnchor, constant: 12),
            servicesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            servicesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Areas section
            areasHeaderLabel.topAnchor.constraint(equalTo: servicesStackView.bottomAnchor, constant: sectionSpacing),
            areasHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            areasHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            areasHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            areasStackView.topAnchor.constraint(equalTo: areasHeaderLabel.bottomAnchor, constant: 12),
            areasStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            areasStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Hours section
            hoursHeaderLabel.topAnchor.constraint(equalTo: areasStackView.bottomAnchor, constant: sectionSpacing),
            hoursHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            hoursHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            hoursHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            hoursTableView.topAnchor.constraint(equalTo: hoursHeaderLabel.bottomAnchor, constant: 12),
            hoursTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            hoursTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            hoursTableView.heightAnchor.constraint(equalToConstant: 44 * 7 + 1),
            
            // Location section
            locationHeaderLabel.topAnchor.constraint(equalTo: hoursTableView.bottomAnchor, constant: sectionSpacing),
            locationHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            locationHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            locationHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            mapView.topAnchor.constraint(equalTo: locationHeaderLabel.bottomAnchor, constant: 12),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // Helper function for determining max Y anchor
    func max(_ lhs: NSLayoutYAxisAnchor, _ rhs: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
        return rhs // A simplification - in practice would need a more complex solution
    }
} 
