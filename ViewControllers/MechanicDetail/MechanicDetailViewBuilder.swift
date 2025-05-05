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
        descriptionLabel.textColor = .label
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
    
    func createAreasView(areas: [String]) -> UIView {
        let containerView = UIView()
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 10
        gridStackView.distribution = .fillEqually
        
        var rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fillEqually
        rowStackView.spacing = 10
        
        for (index, area) in areas.enumerated() {
            if index % 2 == 0 && index > 0 {
                gridStackView.addArrangedSubview(rowStackView)
                rowStackView = UIStackView()
                rowStackView.axis = .horizontal
                rowStackView.distribution = .fillEqually
                rowStackView.spacing = 10
            }
            
            let areaView = createAreaItemView(area: area)
            rowStackView.addArrangedSubview(areaView)
        }
        
        // Add the last row if it has any items
        if rowStackView.arrangedSubviews.count > 0 {
            gridStackView.addArrangedSubview(rowStackView)
        }
        
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(gridStackView)
        
        NSLayoutConstraint.activate([
            gridStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gridStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gridStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gridStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func createAreaItemView(area: String) -> UIView {
        let containerView = UIView()
        
        let pinImageView = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        pinImageView.tintColor = .red
        pinImageView.contentMode = .scaleAspectFit
        
        let areaLabel = UILabel()
        areaLabel.text = area
        areaLabel.font = UIFont.systemFont(ofSize: 14)
        areaLabel.textColor = .label
        areaLabel.numberOfLines = 0
        
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(pinImageView)
        containerView.addSubview(areaLabel)
        
        NSLayoutConstraint.activate([
            pinImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            pinImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pinImageView.widthAnchor.constraint(equalToConstant: 24),
            pinImageView.heightAnchor.constraint(equalToConstant: 24),
            
            areaLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            areaLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 8),
            areaLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            areaLabel.centerYAnchor.constraint(equalTo: pinImageView.centerYAnchor),
            areaLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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
        
        // Convert 24-hour format to 12-hour format
        let components = timeString.components(separatedBy: ":")
        guard components.count >= 2 else { return timeString }
        
        if let hour = Int(components[0]) {
            let period = hour >= 12 ? "PM" : "AM"
            let hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour)
            return "\(hour12):\(components[1]) \(period)"
        }
        
        return timeString
    }
} 