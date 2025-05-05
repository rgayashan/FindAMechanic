import UIKit

class MechanicListSearchHandler: NSObject {
    private weak var viewController: MechanicListViewController?
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredMechanics: [Mechanic] = []
    
    init(viewController: MechanicListViewController) {
        self.viewController = viewController
        super.init()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search mechanics by name or location"
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .darkText
            textField.backgroundColor = .white
        }
        
        viewController?.navigationItem.searchController = searchController
        viewController?.navigationItem.hidesSearchBarWhenScrolling = false
        viewController?.definesPresentationContext = true
    }
    
    func isSearchActive() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    func filterMechanics(_ mechanics: [Mechanic], withText searchText: String) -> [Mechanic] {
        return mechanics.filter { mechanic in
            let nameMatch = mechanic.name.lowercased().contains(searchText.lowercased())
            let addressMatch = (mechanic.addressLine1 + mechanic.addressLine2).lowercased().contains(searchText.lowercased())
            return nameMatch || addressMatch
        }
    }
}

extension MechanicListSearchHandler: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mechanics = viewController?.mechanics else { return }
        filteredMechanics = filterMechanics(mechanics, withText: searchController.searchBar.text ?? "")
        viewController?.updateSearchResults(filteredMechanics)
    }
} 