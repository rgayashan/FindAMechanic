//
//  TableViewDelegateHandler.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit

/// A base class for handling UITableViewDelegate and UITableViewDataSource
class TableViewDelegateHandler: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    weak var tableView: UITableView?
    
    // MARK: - Initialization
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // To be overridden by subclasses
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // To be overridden by subclasses
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // To be overridden by subclasses for specific selection handling
    }
    
    // MARK: - Public Methods
    
    /// Register a cell class with the table view
    /// - Parameters:
    ///   - cellClass: The cell class to register
    ///   - identifier: The reuse identifier for the cell
    func registerCell<T: UITableViewCell>(_ cellClass: T.Type, withIdentifier identifier: String) {
        tableView?.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    /// Register a nib with the table view
    /// - Parameters:
    ///   - nibName: The name of the nib file
    ///   - identifier: The reuse identifier for the cell
    func registerNib(nibName: String, withIdentifier identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: identifier)
    }
    
    /// Refresh the table view data
    func refreshData() {
        tableView?.reloadData()
    }
} 
