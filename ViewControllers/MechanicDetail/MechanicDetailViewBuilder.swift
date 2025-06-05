//
//  MechanicDetailViewBuilder.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit
import MapKit

class MechanicDetailViewBuilder {
    func createServiceView(service: Service) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        
        let titleLabel = UILabel()
        titleLabel.text = service.title
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.25, green: 0.47, blue: 0.68, alpha: 1.0)
        titleLabel.numberOfLines = 0
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = service.description
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "wrench.and.screwdriver.fill")
        iconView.tintColor = UIColor(red: 0.25, green: 0.47, blue: 0.68, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        return containerView
    }
    
    func createAreasView(areas: [ServiceArea]) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        for area in areas {
            let areaView = createAreaItemView(area: area)
            stackView.addArrangedSubview(areaView)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        return containerView
    }
    
    private func createAreaItemView(area: ServiceArea) -> UIView {
        let containerView = UIView()
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "location.circle.fill")
        iconView.tintColor = UIColor(red: 0.25, green: 0.47, blue: 0.68, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        
        let nameLabel = UILabel()
        nameLabel.text = "\(area.cityName) - \(area.postalCode)"
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .darkGray
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(iconView)
        containerView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        return containerView
    }
    
    func setMapLocation(mapView: MKMapView, locations: [MechanicLocation]) {
        guard let firstLocation = locations.first else { return }
        
        let region = MKCoordinateRegion(
            center: firstLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: false)
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.name
            annotation.subtitle = location.address
            mapView.addAnnotation(annotation)
        }
    }
    
    func formatTime(_ timeString: String) -> String {
        // If empty time string, return empty string
        if timeString.isEmpty {
            return ""
        }
        
        print("Debug - Formatting time string: '\(timeString)'")
        
        // Split the time string into components
        let components = timeString.components(separatedBy: ":")
        guard components.count >= 2 else {
            print("Debug - Invalid time format: '\(timeString)'")
            return timeString
        }
        
        if let hour = Int(components[0]) {
            // Handle 24-hour format conversion to 12-hour format
            let period = hour >= 12 ? "PM" : "AM"
            let hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
            
            // Format minutes
            let minutes = components[1]
            
            let formattedTime = String(format: "%d:%@ %@", hour12, minutes, period)
            print("Debug - Formatted time: '\(formattedTime)'")
            return formattedTime
        }
        
        print("Debug - Could not parse hour from: '\(timeString)'")
        return timeString
    }
} 
