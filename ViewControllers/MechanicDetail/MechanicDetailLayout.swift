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
        
        // Store constraints that need to be updated when sections are hidden
        var constraints: [NSLayoutConstraint] = []
        
        // Basic info constraints (always visible)
        constraints += [
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 300),
            
            logoImageView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: padding),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addressLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            phoneLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ]
        
        // Services section constraints
        let servicesTopAnchor = max(logoImageView.bottomAnchor, phoneLabel.bottomAnchor)
        constraints += [
            servicesHeaderLabel.topAnchor.constraint(equalTo: servicesTopAnchor, constant: padding * 2),
            servicesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            servicesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            servicesHeaderLabel.heightAnchor.constraint(equalToConstant: 50),
            
            servicesStackView.topAnchor.constraint(equalTo: servicesHeaderLabel.bottomAnchor, constant: padding),
            servicesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            servicesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ]
        
        // Areas section constraints
        constraints += [
            areasHeaderLabel.topAnchor.constraint(equalTo: servicesStackView.bottomAnchor, constant: padding * 2),
            areasHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            areasHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            areasHeaderLabel.heightAnchor.constraint(equalToConstant: 50),
            
            areasStackView.topAnchor.constraint(equalTo: areasHeaderLabel.bottomAnchor, constant: padding),
            areasStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            areasStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ]
        
        // Hours section constraints
        constraints += [
            hoursHeaderLabel.topAnchor.constraint(equalTo: areasStackView.bottomAnchor, constant: padding * 2),
            hoursHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hoursHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hoursHeaderLabel.heightAnchor.constraint(equalToConstant: 50),
            
            hoursTableView.topAnchor.constraint(equalTo: hoursHeaderLabel.bottomAnchor, constant: padding),
            hoursTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            hoursTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            hoursTableView.heightAnchor.constraint(equalToConstant: 44 * 7 + 1)
        ]
        
        // Location section constraints
        constraints += [
            locationHeaderLabel.topAnchor.constraint(equalTo: hoursTableView.bottomAnchor, constant: padding * 2),
            locationHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            locationHeaderLabel.heightAnchor.constraint(equalToConstant: 50),
            
            mapView.topAnchor.constraint(equalTo: locationHeaderLabel.bottomAnchor, constant: padding),
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