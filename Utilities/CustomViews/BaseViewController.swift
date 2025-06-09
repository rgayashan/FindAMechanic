//
//  BaseViewController.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

/// A base view controller class that implements ViewControllerSetupProtocol
/// and includes common functionality
class BaseViewController: UIViewController, ViewControllerSetupProtocol {
    
    // MARK: - Properties
    
    var keyboardManager: KeyboardManager?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        performSetup()
    }
    
    // MARK: - ViewControllerSetupProtocol Implementation
    
    func setupUI() {
        // To be overridden by subclasses
    }
    
    func setupConstraints() {
        // To be overridden by subclasses
    }
    
    func setupDelegates() {
        // To be overridden by subclasses
    }
    
    func addSubviews() {
        // To be overridden by subclasses
    }
    
    func setupAdditionalConfigurations() {
        // To be overridden by subclasses
    }
    
    // MARK: - Helper Methods
    
    /// Sets up keyboard handling
    /// - Parameter scrollView: Optional scroll view that will be adjusted when keyboard appears
    func setupKeyboardHandling(scrollView: UIScrollView? = nil) {
        keyboardManager = KeyboardManager(viewController: self, scrollView: scrollView)
        keyboardManager?.setupTapGestureToDismissKeyboard(in: view)
    }
    
    /// Presents an alert with a title and message
    /// - Parameters:
    ///   - title: The title of the alert
    ///   - message: The message of the alert
    ///   - okAction: The action to perform when the OK button is tapped
    func showAlert(title: String, message: String, okAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okAction?()
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    
    func confirmationAlert(title: String, message: String, cancelAction: @escaping () -> Void, confirmAction: @escaping () -> Void, cancelText: String, confirmText: String) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel) { _ in
            cancelAction()
        })
        
        alert.addAction(UIAlertAction(title: confirmText, style: .default) { _ in
            confirmAction()
        })
        
        return alert
    }
    
    func showToast(message: String, dismissPopupAfter: Bool = false) {
        // Calculate the width needed for the message
        let font = UIFont(name: "Montserrat-Light", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
        let messageSize = (message as NSString).size(withAttributes: [.font: font])
        
        // Add padding and ensure minimum and maximum width
        let padding: CGFloat = 20
        let minWidth: CGFloat = 150
        let maxWidth = self.view.frame.width - 40 // 20 points padding on each side
        let toastWidth = min(max(messageSize.width + padding * 2, minWidth), maxWidth)
        
        // Calculate height based on the text wrapping
        let toastLabel = UILabel()
        toastLabel.font = font
        toastLabel.numberOfLines = 0 // Allow multiple lines
        toastLabel.text = message
        
        let height: CGFloat = 40 // Minimum height
        
        // Position the toast at the bottom of the screen
        let xPos = (self.view.frame.width - toastWidth) / 2
        let yPos = self.view.frame.height - height - 100 // 100 points from bottom
        
        toastLabel.frame = CGRect(x: xPos, y: yPos, width: toastWidth, height: height)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        // Add padding to the text
        toastLabel.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { [weak self] _ in
            toastLabel.removeFromSuperview()
            if dismissPopupAfter {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
        })
    }
    
    /// Shows a loading indicator
    /// - Parameter message: Optional message to show with the loading indicator
    func showLoading(message: String? = nil) {
        // Create a loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        // Create a container view
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 10
        
        // Add views to hierarchy
        containerView.addSubview(activityIndicator)
        view.addSubview(containerView)
        
        // Add message label if needed
        if let message = message {
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.textColor = .white
            messageLabel.textAlignment = .center
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(messageLabel)
            
            NSLayoutConstraint.activate([
                messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8),
                messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            ])
        }
        
        // Setup constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: message != nil ? -20 : 0)
        ])
        
        // Tag the view for removal later
        containerView.tag = 999
    }
    
    /// Hides the loading indicator
    func hideLoading() {
        if let loadingView = view.viewWithTag(999) {
            loadingView.removeFromSuperview()
        }
    }
}
