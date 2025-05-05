//
//  LoadingRefreshControl.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

class LoadingRefreshControl: UIRefreshControl {
    
    private let loadingView = UIView()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let label = UILabel()
    
    override init() {
        super.init()
        setupRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        tintColor = .clear
        backgroundColor = .clear
        
        // Setup container view
        loadingView.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        loadingView.layer.cornerRadius = 12
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView)
        
        // Setup spinner
        spinner.color = .systemBlue
        spinner.hidesWhenStopped = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(spinner)
        
        // Setup label
        label.text = "Loading mechanics..."
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(label)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),
            loadingView.heightAnchor.constraint(equalToConstant: 36),
            
            spinner.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 12),
            spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: spinner.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -12)
        ])
        
        // Start the spinner by default
        spinner.startAnimating()
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        
        // Initial state for animations
        loadingView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        loadingView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.loadingView.alpha = 1
            self.loadingView.transform = .identity
        })
        
        // Create continuous subtle pulse animation
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.8
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.05
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        loadingView.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    override func endRefreshing() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.loadingView.alpha = 0
        }) { _ in
            self.loadingView.layer.removeAnimation(forKey: "pulse")
            super.endRefreshing()
        }
    }
}
