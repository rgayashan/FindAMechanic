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
    private let searchController = UISearchController(searchResultsController: nil)
    private var mechanics = [Mechanic]()
    private var filteredMechanics = [Mechanic]()
    private var currentPage = 1
    private let itemsPerPage = 10
    private var isLoading = false
    private var hasMoreData = true
    private var isSearching = false
    private let emptyStateView = UIView()
    private let navigationDelegate = MechanicListNavigationDelegate()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = navigationDelegate
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
        setupEmptyStateView()
        fetchMechanics(page: currentPage)
    }
    
    // MARK: - Setup Methods
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
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search mechanics by name or location"
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .darkText
            textField.backgroundColor = .white
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        view.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MechanicTableViewCell.self, forCellReuseIdentifier: "MechanicCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        let customRefreshControl = LoadingRefreshControl()
        customRefreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = customRefreshControl
    }
    
    private func setupEmptyStateView() {
        emptyStateView.isHidden = true
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "No mechanics found"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView.addSubview(imageView)
        emptyStateView.addSubview(label)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 200),
            emptyStateView.heightAnchor.constraint(equalToConstant: 200),
            
            imageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor)
        ])
    }
    
    // MARK: - Data Methods
    @objc private func refreshData() {
        currentPage = 1
        hasMoreData = true
        fetchMechanics(page: currentPage)
    }
    
    private func fetchMechanics(page: Int) {
        guard !isLoading, hasMoreData else { return }
        
        isLoading = true
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        tableView.tableFooterView = spinner
        
        MachanicListDataService.shared.getMechanics(page: page, itemsPerPage: itemsPerPage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.tableView.tableFooterView = nil
                self.tableView.refreshControl?.endRefreshing()
                
                switch result {
                case .success(let newMechanics):
                    self.hasMoreData = newMechanics.count == self.itemsPerPage
                    
                    if page == 1 {
                        self.mechanics = newMechanics
                    } else {
                        self.mechanics.append(contentsOf: newMechanics)
                    }
                    
                    if self.isSearchActive() {
                        self.filterContentForSearchText(self.searchController.searchBar.text ?? "")
                    }
                    
                    self.tableView.reloadData()
                    self.showEmptyStateIfNeeded()
                    
                case .failure(let error):
                    print("Error fetching mechanics: \(error)")
                    self.showErrorAlert()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func isSearchActive() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        // Previous filter mechanics code
        filteredMechanics = mechanics.filter { mechanic in
            let nameMatch = mechanic.name.lowercased().contains(searchText.lowercased())
            let addressMatch = (mechanic.addressLine1 + mechanic.addressLine2).lowercased().contains(searchText.lowercased())
            return nameMatch || addressMatch
        }
        
        // Save current visible cells for animation
        let visibleCells = tableView.visibleCells
        
        // Create more interesting transition for search results
        UIView.animate(withDuration: 0.25, animations: {
            // Fade out and slightly scale down current visible cells
            for cell in visibleCells {
                cell.alpha = 0.0
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }) { _ in
            self.tableView.reloadData()
            self.showEmptyStateIfNeeded()
            
            // Get new visible cells after reload
            let newVisibleCells = self.tableView.visibleCells
            
            // Set initial state for appearing cells
            for cell in newVisibleCells {
                cell.alpha = 0.0
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            
            // Animate them in with a slight stagger
            for (index, cell) in newVisibleCells.enumerated() {
                UIView.animate(withDuration: 0.3, delay: Double(index) * 0.05,
                               usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5,
                               options: [], animations: {
                    cell.alpha = 1.0
                    cell.transform = .identity
                })
            }
        }
    }
    
    // Replace the showEmptyStateIfNeeded method in MechanicListViewController
    func showEmptyStateIfNeeded() {
        let isEmpty = isSearchActive() && filteredMechanics.isEmpty
        
        if isEmpty && emptyStateView.isHidden {
            // Setup initial state for animation
            emptyStateView.alpha = 0
            emptyStateView.isHidden = false
            emptyStateView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).translatedBy(x: 0, y: 20)
            
            // Create spring animation
            UIView.animate(withDuration: 0.5, delay: 0.1,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5,
                           options: [], animations: {
                self.emptyStateView.alpha = 1
                self.emptyStateView.transform = .identity
                self.tableView.alpha = 0.3
            })
        } else if !isEmpty && !emptyStateView.isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.emptyStateView.alpha = 0
                self.emptyStateView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).translatedBy(x: 0, y: 20)
                self.tableView.alpha = 1
            }) { _ in
                self.emptyStateView.isHidden = true
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to load mechanics", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToDetailView(for mechanic: Mechanic) {
        let detailVC = MechanicDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MechanicListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive() {
            return filteredMechanics.count
        }
        return mechanics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MechanicCell", for: indexPath) as! MechanicTableViewCell
        
        let mechanic: Mechanic
        if isSearchActive() {
            mechanic = filteredMechanics[indexPath.row]
        } else {
            mechanic = mechanics[indexPath.row]
        }
        
        cell.configure(with: mechanic)
        cell.delegate = self
        
        // Calculate delay based on cell index for staggered animation
        let delay = Double(indexPath.row) * 0.05 // 50ms delay between cells
        cell.animateOnAppear(withDelay: delay)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension MechanicListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mechanic: Mechanic
        if isSearchActive() {
            mechanic = filteredMechanics[indexPath.row]
        } else {
            mechanic = mechanics[indexPath.row]
        }
        
        navigateToDetailView(for: mechanic)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isSearchActive() {
            let position = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let scrollViewHeight = scrollView.frame.size.height
            
            if position > (contentHeight - scrollViewHeight - 100), !isLoading, hasMoreData {
                currentPage += 1
                fetchMechanics(page: currentPage)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension MechanicListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}

// MARK: - MechanicTableViewCellDelegate
extension MechanicListViewController: MechanicTableViewCellDelegate {
    func didTapBookButton(for mechanic: Mechanic) {
        navigateToDetailView(for: mechanic)
    }
}
