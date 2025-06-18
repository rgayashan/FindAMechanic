//
//  MechanicDetailComponents.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//


import UIKit
import MapKit

struct MechanicDetailComponents {
    static func createHeaderImageView() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        
        // Create the blurred background image view
        let blurredImageView = UIImageView()
        blurredImageView.contentMode = .scaleAspectFill
        blurredImageView.clipsToBounds = true
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the original image view
        let originalImageView = UIImageView()
        originalImageView.contentMode = .scaleAspectFit
        originalImageView.clipsToBounds = true
        originalImageView.translatesAutoresizingMaskIntoConstraints = false
        originalImageView.backgroundColor = .clear
        
        // Add blur effect to the background image
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to container
        containerView.addSubview(blurredImageView)
        containerView.addSubview(blurEffectView)
        containerView.addSubview(originalImageView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            blurredImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurredImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurredImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurredImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            originalImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            originalImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            originalImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            originalImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            originalImageView.heightAnchor.constraint(equalTo: originalImageView.widthAnchor, multiplier: 0.5625)
        ])
        
        // Store references to both image views
        containerView.tag = 100 // Use this tag to identify the container view
        blurredImageView.tag = 101 // Use this tag to identify the blurred image view
        originalImageView.tag = 102 // Use this tag to identify the original image view
        
        return containerView
    }
    
    static func createLogoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOpacity = 0.2
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    static func createNameLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createAddressLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createPhoneLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createSectionHeaderLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(named: "theme-light-bg")
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 12
        stackView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.5)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func createMapView() -> MKMapView {
        let map = MKMapView()
        map.layer.cornerRadius = 12
        map.clipsToBounds = true
        map.layer.borderWidth = 1
        map.layer.borderColor = UIColor.systemGray4.cgColor
        map.layer.shadowColor = UIColor.black.cgColor
        map.layer.shadowOffset = CGSize(width: 0, height: 2)
        map.layer.shadowRadius = 4
        map.layer.shadowOpacity = 0.1
        map.layer.masksToBounds = false
        map.isZoomEnabled = false
        map.isScrollEnabled = false
        map.isUserInteractionEnabled = false
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }
    
    static func createHoursTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.layer.borderColor = UIColor.systemGray4.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 12
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tableView.layer.shadowRadius = 4
        tableView.layer.shadowOpacity = 0.1
        tableView.layer.masksToBounds = false
        tableView.separatorStyle = .none
        return tableView
    }
} 
