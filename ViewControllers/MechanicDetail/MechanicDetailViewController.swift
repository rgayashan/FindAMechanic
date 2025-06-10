//
//  MechanicDetailViewController.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit
import MapKit

class MechanicDetailViewController: BaseViewController {
    
    // MARK: - Properties
    var mechanic: MechanicDetails?
    var mechanicID: String?
    private let dataService = MachanicDetailsDataService.shared
    private let viewBuilder = MechanicDetailViewBuilder()
    private lazy var layoutManager = MechanicDetailLayout(viewController: self)
    private lazy var tableDelegate = MechanicDetailTableDelegate(viewController: self)
    private lazy var mapDelegate = MechanicDetailMapDelegate(viewController: self)
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerImageView = MechanicDetailComponents.createHeaderImageView()
    private let logoImageView = MechanicDetailComponents.createLogoImageView()
    private let nameLabel = MechanicDetailComponents.createNameLabel()
    private let addressLabel = MechanicDetailComponents.createAddressLabel()
    private let phoneLabel = MechanicDetailComponents.createPhoneLabel()
    
    private let servicesHeaderLabel = MechanicDetailComponents.createSectionHeaderLabel(title: "OUR SERVICES")
    private let servicesStackView = MechanicDetailComponents.createStackView(axis: .vertical, spacing: 20)
    
    private let areasHeaderLabel = MechanicDetailComponents.createSectionHeaderLabel(title: "SERVICING AREAS")
    private let areasStackView = MechanicDetailComponents.createStackView(axis: .vertical, spacing: 10)
    
    private let hoursHeaderLabel = MechanicDetailComponents.createSectionHeaderLabel(title: "OPENING HOURS")
    private let hoursTableView = MechanicDetailComponents.createHoursTableView()
    
    private let locationHeaderLabel = MechanicDetailComponents.createSectionHeaderLabel(title: "OUR LOCATION")
    private let mapView = MechanicDetailComponents.createMapView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alpha = 0
        setupView()
        fetchMechanicDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTabBar(show: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateTabBar(show: true)
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .white
        setupScrollView()
        setupNavigationBar()
        scrollView.isHidden = true
        setupComponents()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutManager.setupScrollView(in: view, scrollView: scrollView, contentView: contentView)
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        let inquareButton = UIBarButtonItem(title: "Inquiry", style: .plain, target: self, action: #selector(inquiryButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = inquareButton
    }
    
    private func setupComponents() {
        [headerImageView, logoImageView, nameLabel, addressLabel, phoneLabel,
         servicesHeaderLabel, servicesStackView, areasHeaderLabel, areasStackView,
         hoursHeaderLabel, hoursTableView, locationHeaderLabel, mapView].forEach {
            contentView.addSubview($0)
        }
        
        // Add tag to phone label for layout reference
        phoneLabel.tag = 999
        
        layoutManager.setupContentConstraints(
            in: contentView,
            headerImageView: headerImageView,
            logoImageView: logoImageView,
            nameLabel: nameLabel,
            addressLabel: addressLabel,
            phoneLabel: phoneLabel,
            servicesHeaderLabel: servicesHeaderLabel,
            servicesStackView: servicesStackView,
            areasHeaderLabel: areasHeaderLabel,
            areasStackView: areasStackView,
            hoursHeaderLabel: hoursHeaderLabel,
            hoursTableView: hoursTableView,
            locationHeaderLabel: locationHeaderLabel,
            mapView: mapView
        )
        
        setupTableView()
        setupMapView()
    }
    
    private func setupTableView() {
        hoursTableView.delegate = tableDelegate
        hoursTableView.dataSource = tableDelegate
        hoursTableView.register(UITableViewCell.self, forCellReuseIdentifier: "hourCell")
        hoursTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        hoursTableView.backgroundColor = .white
        hoursTableView.isHidden = false
        hoursTableView.layer.borderWidth = 1
        hoursTableView.layer.borderColor = UIColor.systemGray4.cgColor
        hoursTableView.layer.cornerRadius = 8
        hoursTableView.clipsToBounds = true
        hoursTableView.isScrollEnabled = false
        hoursTableView.rowHeight = 44
    }
    
    private func setupMapView() {
        mapView.delegate = mapDelegate
    }
    
    // MARK: - Data Loading Methods
    private func fetchMechanicDetails() {
        guard let mechanicID = mechanicID else {
            let alert = self.confirmationAlert(
                title: "Error",
                message: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mechanic ID not found"]).localizedDescription,
                cancelAction: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                },
                confirmAction: { [weak self] in
                    self?.fetchMechanicDetails()
                },
                cancelText: "Cancel",
                confirmText: "Retry"
            )
            present(alert, animated: true)
            return
        }
        
        LoadingIndicator.show(in: view)
        
        dataService.getMechanicDetails(tenantId: mechanicID) { [weak self] result in
            DispatchQueue.main.async {
                LoadingIndicator.hide(animated: true) {
                    switch result {
                    case .success(let mechanic):
                        self?.mechanic = mechanic
                        self?.updateUI()
                        self?.showContent()
                    case .failure(let error):
                        let alert = self?.confirmationAlert(
                            title: "Error",
                            message: error.localizedDescription,
                            cancelAction: { [weak self] in
                                self?.navigationController?.popViewController(animated: true)
                            },
                            confirmAction: { [weak self] in
                                self?.fetchMechanicDetails()
                            },
                            cancelText: "Cancel",
                            confirmText: "Retry"
                        )
                        if let alert = alert {
                            self?.present(alert, animated: true)
                        }
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
        
        loadImage(from: mechanic.logo, into: logoImageView)
        loadImage(from: mechanic.bannerImage, into: headerImageView)
        
        // Services section
        if mechanic.services.isEmpty {
            servicesHeaderLabel.isHidden = true
            servicesStackView.isHidden = true
        } else {
            servicesHeaderLabel.isHidden = false
            servicesStackView.isHidden = false
            updateServices(mechanic.services)
        }
        
        // Areas section
        if mechanic.servicingAreas.isEmpty {
            areasHeaderLabel.isHidden = true
            areasStackView.isHidden = true
        } else {
            areasHeaderLabel.isHidden = false
            areasStackView.isHidden = false
            updateAreas(mechanic.servicingAreas)
        }
        
        // Hours section
        if mechanic.openingHours.isEmpty {
            hoursHeaderLabel.isHidden = true
            hoursTableView.isHidden = true
        } else {
            hoursHeaderLabel.isHidden = false
            hoursTableView.isHidden = false
            hoursTableView.reloadData()
        }
        
        // Location section
        if mechanic.locations.isEmpty {
            locationHeaderLabel.isHidden = true
            mapView.isHidden = true
        } else {
            locationHeaderLabel.isHidden = false
            mapView.isHidden = false
            viewBuilder.setMapLocation(mapView: mapView, locations: mechanic.locations)
        }
        
        // Update layout constraints based on visibility
        layoutManager.updateSectionConstraints(
            servicesHeaderLabel: servicesHeaderLabel,
            servicesStackView: servicesStackView,
            areasHeaderLabel: areasHeaderLabel,
            areasStackView: areasStackView,
            hoursHeaderLabel: hoursHeaderLabel,
            hoursTableView: hoursTableView,
            locationHeaderLabel: locationHeaderLabel,
            mapView: mapView
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneLabelTapped))
        phoneLabel.isUserInteractionEnabled = true
        phoneLabel.addGestureRecognizer(tapGesture)
    }
    
    private func loadImage(from urlString: String?, into imageView: UIImageView) {
        guard let urlString = urlString else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }.resume()
        } else if let data = Data(base64Encoded: urlString), let image = UIImage(data: data) {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func updateServices(_ services: [Service]) {
        servicesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for service in services {
            let serviceView = viewBuilder.createServiceView(service: service)
            servicesStackView.addArrangedSubview(serviceView)
        }
    }
    
    private func updateAreas(_ areas: [ServiceArea]) {
        areasStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let areasView = viewBuilder.createAreasView(areas: areas)
        areasStackView.addArrangedSubview(areasView)
    }
    
    private func showContent() {
        scrollView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.scrollView.alpha = 1.0
        }
    }
    
    private func animateTabBar(show: Bool) {
        if let tabBar = tabBarController?.tabBar {
            if show {
                tabBar.isHidden = false
                tabBar.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    tabBar.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    tabBar.alpha = 0
                } completion: { _ in
                    tabBar.isHidden = true
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func inquiryButtonTapped() {
        guard let mechanic = mechanic else { return }
        InquiryPopupHelper.showInquiryPopup(from: self, mechanicName: mechanic.name, delegate: self, tenantId: mechanic.tenantId)
    }
    
    @objc private func phoneLabelTapped() {
        guard let phone = mechanic?.phone, let url = URL(string: "tel://\(phone)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Public Methods
    func configure(with mechanic: MechanicDetails) {
        self.mechanic = mechanic
        if isViewLoaded {
            updateUI()
        }
    }
}

// MARK: - InquiryPopupDelegate
extension MechanicDetailViewController: InquiryPopupDelegate {
    func inquirySubmitted(inquiry: InquiryForm) {
        LoadingIndicator.show(in: view)
        
        InquiryService.shared.submitInquiry(inquiry: inquiry) { [weak self] success, error in
            DispatchQueue.main.async {
                LoadingIndicator.hide(animated: true) {
                    if success {
                        self?.showAlert(title: "Success", message: "Your inquiry has been submitted successfully!")
                    } else {
                        self?.showAlert(title: "Error", message: error?.localizedDescription ?? "Failed to submit inquiry")
                    }
                }
            }
        }
    }
}
