//
//  MechanicDetailViewController.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit
import MapKit

class MechanicDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var mechanic: MechanicDetails?
    private let dataService = MachanicDetailsDataService.shared
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let servicesHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "OUR SERVICES"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.25, green: 0.47, blue: 0.68, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let servicesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let areasHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "SERVICING AREAS"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.25, green: 0.47, blue: 0.68, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let areasStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let hoursHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "OPENING HOURS"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.25, green: 0.47, blue: 0.68, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let hoursTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let locationHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "OUR LOCATION"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.25, green: 0.47, blue: 0.68, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 8
        map.clipsToBounds = false
        map.isZoomEnabled = false
        map.isScrollEnabled = false
        map.isUserInteractionEnabled = false
        return map
    }()
    
    // Activity indicator for loading states
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alpha = 0
        setupView()
        fetchMechanicDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Animate tab bar hiding
        if let tabBar = tabBarController?.tabBar {
            UIView.animate(withDuration: 0.3) {
                tabBar.alpha = 0
            } completion: { _ in
                tabBar.isHidden = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Animate tab bar showing
        if let tabBar = tabBarController?.tabBar {
            tabBar.isHidden = false
            tabBar.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                tabBar.alpha = 1
            }
        }
    }
    
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupNavigationBar()
        
        // Initially hide content until data is loaded
        scrollView.isHidden = true
        
        setupUI()
        setupMapView()
        setupConstraints()
        setupTableView()
        //        setupActivityIndicator()
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        let inquareButton = UIBarButtonItem(title: "Inquiry", style: .plain, target: self, action: #selector(inquiryButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = inquareButton
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
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
    private func setupUI() {
        // Add subviews to content view
        [headerImageView, logoImageView, nameLabel, addressLabel, phoneLabel,
         servicesHeaderLabel, servicesStackView, areasHeaderLabel, areasStackView,
         hoursHeaderLabel, hoursTableView, locationHeaderLabel, mapView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupMapView() {
        mapView.delegate = self
    }
    
    private func setupTableView() {
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        hoursTableView.register(UITableViewCell.self, forCellReuseIdentifier: "hourCell")
        hoursTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    
    private func setupConstraints() {
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
    
    // MARK: - Data Loading Methods
    private func fetchMechanicDetails() {
        // Get mechanic ID from the current screen or from navigation parameters
        let mechanicID = mechanic?.id ?? "1" // Default to ID 1 if none provided
        
        // Show loading indicator using our LoadingIndicator component
        LoadingIndicator.show(in: view)
        
        // Get mechanic details from DataService
        dataService.getMechanicDetails(mechanicID: mechanicID) { [weak self] result in
            // Execute UI updates on the main thread
            DispatchQueue.main.async {
                // Hide loading indicator
                LoadingIndicator.hide(animated: true) {
                    // Process the result
                    switch result {
                    case .success(let mechanic):
                        self?.mechanic = mechanic
                        self?.updateUI()
                        
                        // Show content after data is loaded and UI is updated
                        self?.scrollView.isHidden = false
                        
                        // Add a fade-in animation for better UX
                        UIView.animate(withDuration: 0.3) {
                            self?.scrollView.alpha = 1.0
                        }
                        
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            }
        }
    }
    
    private func updateUI() {
        guard let mechanic = mechanic else { return }
        
        title = mechanic.name
        nameLabel.text = mechanic.name
        addressLabel.text = mechanic.address
        phoneLabel.text = "Phone: \(mechanic.phone)"
        
        // Load logo image - handle string as URL or base64
        if let logoString = mechanic.logo {
            loadImage(from: logoString) { [weak self] image in
                self?.logoImageView.image = image ?? UIImage(named: "placeholder")
            }
        } else {
            logoImageView.image = UIImage(named: "placeholder")
        }
        
        // Load header image - handle string as URL or base64
        if let headerImageString = mechanic.headerImage {
            loadImage(from: headerImageString) { [weak self] image in
                self?.headerImageView.image = image ?? UIImage(named: "placeholder")
            }
        } else {
            headerImageView.image = UIImage(named: "placeholder")
        }
        
        // Update services stack
        servicesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for service in mechanic.services {
            let serviceView = createServiceView(service: service)
            servicesStackView.addArrangedSubview(serviceView)
        }
        
        // Update areas stack
        areasStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let areasView = createAreasView(areas: mechanic.servicingAreas)
        areasStackView.addArrangedSubview(areasView)
        
        // Update map
        setMapLocation(locations: mechanic.locations)
        
        hoursTableView.reloadData()
    }
    
    // Helper function to load images from string (URL or base64)
    private func loadImage(from string: String, completion: @escaping (UIImage?) -> Void) {
        // First check if it's a valid URL
        if let url = URL(string: string) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
            }.resume()
        }
        // If not a URL, try as base64
        else if let data = Data(base64Encoded: string), let image = UIImage(data: data) {
            completion(image)
        }
        // If neither works, return nil
        else {
            completion(nil)
        }
    }
    
    private func createServiceView(service: Service) -> UIView {
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
    
    private func createAreasView(areas: [String]) -> UIView {
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
    
    private func setMapLocation(locations: [MechanicLocation]) {
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
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.fetchMechanicDetails()
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Helper Functions
    private func max(_ lhs: NSLayoutYAxisAnchor, _ rhs: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
        // This is a simplified way to get the max Y coordinate between two anchors
        // In a real app, you might want to use a different approach
        return rhs
    }
    
    // MARK: - Action Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func bookButtonTapped() {
        // Handle booking appointment
        let alert = UIAlertController(title: "Book Appointment", message: "Would you like to book an appointment with \(mechanic?.name ?? "this mechanic")?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Book", style: .default) { [weak self] _ in
            // Navigate to booking screen or show booking form
            // self?.navigateToBookingScreen()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func inquiryButtonTapped() {
        InquiryPopupHelper.showInquiryPopup(from: self, delegate: self)
    }
    
    // MARK: - Public Methods
    func configure(with mechanic: MechanicDetails) {
        self.mechanic = mechanic
        if isViewLoaded {
            updateUI()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MechanicDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mechanic?.openingHours.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell", for: indexPath)
        
        guard let hour = mechanic?.openingHours[indexPath.row] else {
            return cell
        }
        
        // Configure cell
        var content = cell.defaultContentConfiguration()
        content.text = hour.day
        
        if hour.status == "Open" {
            let timeString = "\(formatTime(hour.startTime)) - \(formatTime(hour.endTime))"
            content.secondaryText = timeString
            content.secondaryTextProperties.color = .systemGreen
        } else {
            content.secondaryText = "Closed"
            content.secondaryTextProperties.color = .systemRed
        }
        
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func formatTime(_ timeString: String) -> String {
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


// MARK: - MKMapViewDelegate
extension MechanicDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "MechanicPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }
        
        let placemark = MKPlacemark(coordinate: annotation.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = annotation.title ?? mechanic?.name
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

// MARK: - InquiryPopupDelegate
extension MechanicDetailViewController: InquiryPopupDelegate {
    func inquirySubmitted(inquiry: InquiryForm) {
        // Show loading indicator
        LoadingIndicator.show(in: view)
        
        // Submit the inquiry
        InquiryService.shared.submitInquiry(inquiry: inquiry) { [weak self] success, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Hide loading indicator
                LoadingIndicator.hide(animated: true) {
                    if success {
                        // Show success message
                        self.showAlert(title: "Success", message: "Your inquiry has been submitted successfully!")
                    } else {
                        // Show error message
                        self.showAlert(title: "Error", message: error?.localizedDescription ?? "Failed to submit inquiry")
                    }
                }
            }
        }
    }
}
