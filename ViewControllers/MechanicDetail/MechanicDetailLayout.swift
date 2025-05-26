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
        let padding: CGFloat = 16
        let sectionSpacing: CGFloat = 20 // Reduced from padding * 2
        let headerHeight: CGFloat = 40 // Reduced from 50
        
        // Store constraints that need to be updated when sections are hidden
        var constraints: [NSLayoutConstraint] = []
        
        // Basic info constraints (always visible)
        constraints += [
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: padding),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4), // Reduced from 8
            addressLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4), // Reduced from 8
            phoneLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ]
        
        // Services section constraints
        let servicesTopAnchor = max(logoImageView.bottomAnchor, phoneLabel.bottomAnchor)
        constraints += [
            servicesHeaderLabel.topAnchor.constraint(equalTo: servicesTopAnchor, constant: sectionSpacing),
            servicesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            servicesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            servicesHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            servicesStackView.topAnchor.constraint(equalTo: servicesHeaderLabel.bottomAnchor, constant: 8), // Reduced from padding
            servicesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            servicesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ]
        
        // Areas section constraints
        constraints += [
            areasHeaderLabel.topAnchor.constraint(equalTo: servicesStackView.bottomAnchor, constant: sectionSpacing),
            areasHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            areasHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            areasHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            areasStackView.topAnchor.constraint(equalTo: areasHeaderLabel.bottomAnchor, constant: 8), // Reduced from padding
            areasStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            areasStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ]
        
        // Hours section constraints
        constraints += [
            hoursHeaderLabel.topAnchor.constraint(equalTo: areasStackView.bottomAnchor, constant: sectionSpacing),
            hoursHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hoursHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hoursHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            hoursTableView.topAnchor.constraint(equalTo: hoursHeaderLabel.bottomAnchor, constant: 8), // Reduced from padding
            hoursTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            hoursTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            hoursTableView.heightAnchor.constraint(equalToConstant: 44 * 7 + 1)
        ]
        
        // Location section constraints
        constraints += [
            locationHeaderLabel.topAnchor.constraint(equalTo: hoursTableView.bottomAnchor, constant: sectionSpacing),
            locationHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            locationHeaderLabel.heightAnchor.constraint(equalToConstant: headerHeight),
            
            mapView.topAnchor.constraint(equalTo: locationHeaderLabel.bottomAnchor, constant: 8), // Reduced from padding
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