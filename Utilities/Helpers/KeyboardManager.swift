//
//  KeyboardManager.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit

/// A reusable class to handle keyboard appearance and dismissal
class KeyboardManager {
    weak var viewController: UIViewController?
    weak var scrollView: UIScrollView?
    private var originalInset: UIEdgeInsets = .zero
    
    /// Initialize with a view controller and optional scroll view
    /// - Parameters:
    ///   - viewController: The view controller that needs keyboard handling
    ///   - scrollView: Optional scroll view that will be adjusted when keyboard appears
    init(viewController: UIViewController, scrollView: UIScrollView? = nil) {
        self.viewController = viewController
        self.scrollView = scrollView
        if let scrollView = scrollView {
            self.originalInset = scrollView.contentInset
        }
        setupKeyboardNotifications()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: - Public Methods
    
    /// Setup a tap gesture to dismiss keyboard when tapping outside the input fields
    /// - Parameter view: The view to add the gesture to
    func setupTapGestureToDismissKeyboard(in view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private Methods
    
    @objc private func dismissKeyboard() {
        viewController?.view.endEditing(true)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        if let scrollView = self.scrollView {
            // Adjust scroll view insets
            UIView.animate(withDuration: duration) {
                var contentInset = self.originalInset
                contentInset.bottom += keyboardHeight
                scrollView.contentInset = contentInset
                scrollView.scrollIndicatorInsets = contentInset
            }
        } else {
            // Adjust the main view frame
            UIView.animate(withDuration: duration) {
                guard let view = self.viewController?.view else { return }
                view.frame.origin.y = -keyboardHeight / 2
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        if let scrollView = self.scrollView {
            // Reset scroll view insets
            UIView.animate(withDuration: duration) {
                scrollView.contentInset = self.originalInset
                scrollView.scrollIndicatorInsets = self.originalInset
            }
        } else {
            // Reset the main view frame
            UIView.animate(withDuration: duration) {
                guard let view = self.viewController?.view else { return }
                view.frame.origin.y = 0
            }
        }
    }
} 
