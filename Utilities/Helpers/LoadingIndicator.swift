//
//  LoadingIndicator.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import UIKit

class LoadingIndicator {
    
    // MARK: - Properties
    private static var activityIndicator: UIActivityIndicatorView?
    private static var containerView: UIView?
    
    // MARK: - Public Methods
    
    /// Shows a loading indicator centered in the provided view
    /// - Parameters:
    ///   - view: The view to display the loading indicator in
    ///   - style: The style of the activity indicator (default: .medium)
    ///   - backgroundColor: Background color of the container (default: semi-transparent)
    ///   - animated: Whether to animate the appearance (default: true)
    static func show(in view: UIView,
                     style: UIActivityIndicatorView.Style = .medium,
                     backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.2),
                     animated: Bool = true) {
        
        // Create container view
        containerView = UIView()
        guard let containerView = containerView else { return }
        containerView.frame = view.bounds
        containerView.backgroundColor = backgroundColor
        containerView.alpha = 0
        
        // Create activity indicator
        activityIndicator = UIActivityIndicatorView(style: style)
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .darkGray
        
        // Add to view hierarchy
        containerView.addSubview(activityIndicator)
        view.addSubview(containerView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        // Start animating
        activityIndicator.startAnimating()
        
        // Animate appearance if needed
        if animated {
            UIView.animate(withDuration: 0.3) {
                containerView.alpha = 1
            }
        } else {
            containerView.alpha = 1
        }
    }
    
    /// Hides the currently displayed loading indicator
    /// - Parameter animated: Whether to animate the disappearance (default: true)
    /// - Parameter completion: Optional completion handler called when the indicator is hidden
    static func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let containerView = containerView else {
            completion?()
            return
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                containerView.alpha = 0
            }) { _ in
                cleanup()
                completion?()
            }
        } else {
            cleanup()
            completion?()
        }
    }
    
    // MARK: - Private Methods
    
    private static func cleanup() {
        activityIndicator?.stopAnimating()
        containerView?.removeFromSuperview()
        activityIndicator = nil
        containerView = nil
    }
}
