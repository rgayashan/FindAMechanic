//
//  MechanicListSearchHandler.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

class MechanicListSearchHandler: NSObject {
    private weak var viewController: MechanicListViewController?
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredMechanics: [Mechanic] = []
    private let dataService = MachanicListDataService.shared
    private var searchWorkItem: DispatchWorkItem?
    
    init(viewController: MechanicListViewController) {
        self.viewController = viewController
        super.init()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search mechanics by name or suburb"
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black
            textField.backgroundColor = .white
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search mechanics by name or location",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        }
        
        viewController?.navigationItem.searchController = searchController
        viewController?.navigationItem.hidesSearchBarWhenScrolling = false
        viewController?.definesPresentationContext = true
    }
    
    func isSearchActive() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    private func performSearch(with searchText: String) {
        
        // Cancel any pending search
        searchWorkItem?.cancel()
        
        // Create a new work item for the search
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            // Call API with search text
            self.dataService.getMechanics(page: 1, itemsPerPage: 10, search: searchText) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let mechanics):
                        self.viewController?.updateSearchResults(mechanics)
                    case .failure(_):
                        // Handle error if needed
                        self.viewController?.updateSearchResults([])
                    }
                }
            }
        }
        
        // Save the work item reference
        searchWorkItem = workItem
        
        // Execute the work item after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}

extension MechanicListSearchHandler: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            viewController?.updateSearchResults([])
            return
        }
        
        performSearch(with: searchText)
    }
} 
