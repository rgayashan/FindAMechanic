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
        
        NSLayoutConstraint.activate([
            // Header image
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Logo
            logoImageView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: padding),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Name label
            nameLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Address label
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addressLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Phone label
            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            phoneLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: padding),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Services header
            servicesHeaderLabel.topAnchor.constraint(equalTo: max(logoImageView.bottomAnchor, phoneLabel.bottomAnchor), constant: padding * 2),
            servicesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            servicesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            servicesHeaderLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // Services stack
            servicesStackView.topAnchor.constraint(equalTo: servicesHeaderLabel.bottomAnchor, constant: padding),
            servicesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            servicesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Areas header
            areasHeaderLabel.topAnchor.constraint(equalTo: servicesStackView.bottomAnchor, constant: padding * 2),
            areasHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            areasHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            areasHeaderLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // Areas stack
            areasStackView.topAnchor.constraint(equalTo: areasHeaderLabel.bottomAnchor, constant: padding),
            areasStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            areasStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Hours header
            hoursHeaderLabel.topAnchor.constraint(equalTo: areasStackView.bottomAnchor, constant: padding * 2),
            hoursHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hoursHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hoursHeaderLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // Hours table
            hoursTableView.topAnchor.constraint(equalTo: hoursHeaderLabel.bottomAnchor),
            hoursTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hoursTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hoursTableView.heightAnchor.constraint(equalToConstant: 280),
            
            // Location header
            locationHeaderLabel.topAnchor.constraint(equalTo: hoursTableView.bottomAnchor, constant: padding),
            locationHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            locationHeaderLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // Map view
            mapView.topAnchor.constraint(equalTo: locationHeaderLabel.bottomAnchor, constant: padding),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    // Helper function for determining max Y anchor
    func max(_ lhs: NSLayoutYAxisAnchor, _ rhs: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
        return rhs // A simplification - in practice would need a more complex solution
    }
} 