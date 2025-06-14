//
//  MachanicListViewController.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit

class MechanicListViewController: BaseViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    var mechanics = [Mechanic]()
    private var filteredMechanics = [Mechanic]()
    private var currentPage = 1
    private let itemsPerPage = 20
    private var isLoading = false
    private var hasMoreData = true
    private var isSearching = false
    private let emptyStateView = UIView()
    private let dataService = MachanicListDataService.shared
    
    private lazy var searchHandler = MechanicListSearchHandler(viewController: self)
    private lazy var tableHandler = MechanicListTableHandler(viewController: self, tableView: tableView)
    
    var currentMechanics: [Mechanic] {
        return isSearchActive ? filteredMechanics : mechanics
    }
    
    var isSearchActive: Bool {
        return searchHandler.isSearchActive()
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Start loading with refresh indicator
        tableHandler.beginRefreshing()
        fetchMechanics(page: currentPage)
    }
    
    // MARK: - Setup Methods
    internal override func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        setupEmptyStateView()
    }
    
    private func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor(named: "theme-bg")
            navBarAppearance.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 20, weight: .bold)
            ]
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Find a Mechanic"
    }
    
    private func setupTableView() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyStateView() {
        emptyStateView.isHidden = true
        emptyStateView.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: "wrench.and.screwdriver"))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = "No Mechanics Found"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let messageLabel = UILabel()
        messageLabel.text = "Try adjusting your search to find what you're looking for."
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .darkGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        [imageView, titleLabel, messageLabel].forEach { stackView.addArrangedSubview($0) }
        
        emptyStateView.addSubview(stackView)
        view.addSubview(emptyStateView)
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Data Loading
    @objc func refreshData() {
        currentPage = 1
        hasMoreData = true
        tableHandler.beginRefreshing()
        fetchMechanics(page: currentPage)
    }
    
    func loadMoreIfNeeded() {
        guard !isLoading && hasMoreData else { return }
        
        // Show loading indicator only if we have more data to load
        if hasMoreData {
            showLoadingIndicator()
        }
        
        currentPage += 1
        fetchMechanics(page: currentPage)
    }
    
    private func fetchMechanics(page: Int) {
        guard !isLoading, hasMoreData else { return }
        
        isLoading = true
        if page == 1 {
            LoadingIndicator.show(in: view)
        } else {
            showLoadingIndicator()
        }
        
        dataService.getMechanics(page: page, itemsPerPage: itemsPerPage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if page == 1 {
                    LoadingIndicator.hide(animated: true)
                } else {
                    self.hideLoadingIndicator()
                }
                self.handleFetchResult(result, forPage: page)
            }
        }
    }
    
    private func handleFetchResult(_ result: Result<[Mechanic], DataError>, forPage page: Int) {
        isLoading = false
        
        // Always hide loading indicators first
        if page == 1 {
            LoadingIndicator.hide(animated: true)
            tableHandler.endRefreshing()
        } else {
            hideLoadingIndicator()
        }
        
        switch result {
        case .success(let newMechanics):
            // If we get no items or fewer items than requested, we've reached the end
            hasMoreData = !newMechanics.isEmpty && newMechanics.count >= itemsPerPage
            
            if page == 1 {
                mechanics = newMechanics
            } else {
                // Append all items from the backend without filtering
                mechanics.append(contentsOf: newMechanics)
            }
            
            if isSearchActive {
                updateSearchResults(filteredMechanics)
            } else {
                tableHandler.reloadData()
                animateCellsAfterReload()
            }
            
            // Hide loading indicator if we've reached the end
            if !hasMoreData {
                tableView.tableFooterView = nil
            }
            
        case .failure(let error):
            self.showAlert(title: "Error", message: "Failed to load mechanics: \(error.localizedDescription)")
            // Hide loading indicator on error
            tableView.tableFooterView = nil
        }
    }
    
    private func hideLoadingIndicator() {
        tableView.tableFooterView = nil
        tableHandler.endRefreshing()
        LoadingIndicator.hide(animated: true)
    }
    
    // MARK: - UI Updates
    func updateSearchResults(_ filtered: [Mechanic]) {
        if isSearchActive && filtered.isEmpty {
            LoadingIndicator.show(in: view)
        }
        
        filteredMechanics = filtered
        tableHandler.reloadData()
        animateCellsAfterReload()
        showEmptyStateIfNeeded()
        
        if isSearchActive {
            LoadingIndicator.hide(animated: true)
        }
    }
    
    private func showEmptyStateIfNeeded() {
        emptyStateView.isHidden = !(isSearchActive && filteredMechanics.isEmpty)
        tableView.alpha = emptyStateView.isHidden ? 1 : 0.3
    }
    
    private func showLoadingIndicator() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        tableView.tableFooterView = spinner
    }
    
    private func animateCellsAfterReload() {
        let visibleCells = tableView.visibleCells
        _ = visibleCells.count
        
        for (index, cell) in visibleCells.enumerated() {
            guard let mechanicCell = cell as? MechanicTableViewCell else { continue }
            
            // Calculate staggered delay based on cell position
            let delay = Double(index) * 0.1 // 0.1 second delay between each cell
            
            if let containerView = mechanicCell.contentView.subviews.first {
                // Reset initial state
                containerView.transform = CGAffineTransform(translationX: 0, y: 50)
                containerView.alpha = 0
                
                // Apply staggered animation
                MechanicCellAnimator.applyAppearAnimation(to: mechanicCell, containerView: containerView, withDelay: delay)
            }
        }
    }
    
    // MARK: - Navigation
    func navigateToDetail(for mechanic: Mechanic) {
        let detailVC = MechanicDetailViewController()
        detailVC.mechanicID = mechanic.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - MechanicTableViewCellDelegate
extension MechanicListViewController: MechanicTableViewCellDelegate {
    func didTapBookButton(for mechanic: Mechanic) {
        navigateToDetail(for: mechanic)
    }
}
