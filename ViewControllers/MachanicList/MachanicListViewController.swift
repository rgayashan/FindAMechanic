//
//  MachanicListViewController.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit

class MechanicListViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    var mechanics = [Mechanic]()
    private var filteredMechanics = [Mechanic]()
    private var currentPage = 1
    private let itemsPerPage = 10
    private var isLoading = false
    private var hasMoreData = true
    private var isSearching = false
    private let emptyStateView = UIView()
    private let navigationDelegate = MechanicListNavigationDelegate()
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
        navigationController?.delegate = navigationDelegate
        setupUI()
        
        // Start loading with refresh indicator
        tableHandler.beginRefreshing()
        fetchMechanics(page: currentPage)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
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
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
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
        // Add empty state view setup code here if needed
    }
    
    // MARK: - Data Loading
    @objc func refreshData() {
        currentPage = 1
        hasMoreData = true
        tableHandler.beginRefreshing()
        fetchMechanics(page: currentPage)
    }
    
    func loadMoreIfNeeded() {
        guard !isLoading, hasMoreData else { return }
        currentPage += 1
        fetchMechanics(page: currentPage)
    }
    
    private func fetchMechanics(page: Int) {
        guard !isLoading, hasMoreData else { return }
        
        isLoading = true
        showLoadingIndicator()
        
        dataService.getMechanics(page: page, itemsPerPage: itemsPerPage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.hideLoadingIndicator()
                self.handleFetchResult(result, forPage: page)
            }
        }
    }
    
    private func handleFetchResult(_ result: Result<[Mechanic], DataError>, forPage page: Int) {
        isLoading = false
        
        switch result {
        case .success(let newMechanics):
            hasMoreData = newMechanics.count == itemsPerPage
            
            if page == 1 {
                mechanics = newMechanics
            } else {
                mechanics.append(contentsOf: newMechanics)
            }
            
            if isSearchActive {
                updateSearchResults(filteredMechanics)
            } else {
                tableHandler.reloadData()
            }
            
        case .failure:
            showErrorAlert()
        }
    }
    
    // MARK: - UI Updates
    func updateSearchResults(_ filtered: [Mechanic]) {
        filteredMechanics = filtered
        tableHandler.reloadData()
        showEmptyStateIfNeeded()
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
    
    private func hideLoadingIndicator() {
        tableView.tableFooterView = nil
        tableHandler.endRefreshing()
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to load mechanics", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Navigation
    func navigateToDetail(for mechanic: Mechanic) {
        print("Selected mechanic ID: \(mechanic.id)")
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
