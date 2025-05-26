import UIKit
import MapKit

class MechanicDetailViewBuilder {
    func createServiceView(service: Service) -> UIView {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = service.title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.25, green: 0.47, blue: 0.68, alpha: 1.0)
        titleLabel.numberOfLines = 0
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = service.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    func createAreasView(areas: [ServiceArea]) -> UIView {
        let containerView = UIView()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Group areas by postal code
        let groupedAreas = Dictionary(grouping: areas) { $0.postalCode }
        let sortedPostalCodes = groupedAreas.keys.sorted()
        
        for postalCode in sortedPostalCodes {
            if let areas = groupedAreas[postalCode] {
                let areaNames = areas.map { $0.cityName }.sorted()
                let areaText = "\(areaNames.joined(separator: ", ")) - \(postalCode)"
                
                let label = UILabel()
                label.text = areaText
                label.font = UIFont.systemFont(ofSize: 16)
                label.textColor = .darkGray
                label.numberOfLines = 0
                
                stackView.addArrangedSubview(label)
            }
        }
        
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    func setMapLocation(mapView: MKMapView, locations: [MechanicLocation]) {
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotations for each location
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.name
            annotation.subtitle = location.address
            
            mapView.addAnnotation(annotation)
        }
        
        // If there are locations, set the map region to fit all locations
        if !locations.isEmpty {
            var zoomRect = MKMapRect.null
            
            for location in locations {
                let point = MKMapPoint(location.coordinate)
                let pointRect = MKMapRect(x: point.x - 1000, y: point.y - 1000, width: 2000, height: 2000)
                zoomRect = zoomRect.isNull ? pointRect : zoomRect.union(pointRect)
            }
            
            // Add some padding around the annotations
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            mapView.setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
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
