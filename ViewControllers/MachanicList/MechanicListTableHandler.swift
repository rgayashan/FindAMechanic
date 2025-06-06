//
//  MechanicListTableHandler.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

class MechanicListTableHandler: NSObject {
    private weak var viewController: MechanicListViewController?
    private let tableView: UITableView
    private var refreshControl: LoadingRefreshControl?
    
    init(viewController: MechanicListViewController, tableView: UITableView) {
        self.viewController = viewController
        self.tableView = tableView
        super.init()
        setupTableView()
        setupRefreshControl()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MechanicTableViewCell.self, forCellReuseIdentifier: "MechanicCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    private func setupRefreshControl() {
        let customRefreshControl = LoadingRefreshControl()
        customRefreshControl.addTarget(viewController, action: #selector(MechanicListViewController.refreshData), for: .valueChanged)
        refreshControl = customRefreshControl
        tableView.refreshControl = customRefreshControl
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func beginRefreshing() {
        refreshControl?.beginRefreshing(withText: "Loading mechanics...")
    }
    
    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension MechanicListTableHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController?.currentMechanics.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MechanicCell", for: indexPath) as! MechanicTableViewCell
        
        if let mechanic = viewController?.currentMechanics[indexPath.row] {
            cell.configure(with: mechanic)
            cell.delegate = viewController
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MechanicListTableHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let mechanic = viewController?.currentMechanics[indexPath.row] {
            viewController?.navigateToDetail(for: mechanic)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewController = viewController,
              !viewController.isSearchActive else { return }
        
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (contentHeight - scrollViewHeight - 100) {
            viewController.loadMoreIfNeeded()
        }
    }
} 
