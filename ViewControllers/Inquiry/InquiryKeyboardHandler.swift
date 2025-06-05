//
//  InquiryFormHandler.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

class InquiryKeyboardHandler {
    private weak var viewController: UIViewController?
    private weak var containerView: UIView?
    private var keyboardHeight: CGFloat = 0
    
    init(viewController: UIViewController, containerView: UIView) {
        self.viewController = viewController
        self.containerView = containerView
        setupKeyboardNotifications()
        setupTapGesture()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: - Keyboard Handling
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
    
    private func setupTapGesture() {
        guard let containerView = containerView else { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tapGesture)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let viewController = viewController,
              let containerView = containerView,
              let activeField = findActiveField() else { return }
        
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
            
            // Check if the active field is hidden by keyboard
            let convertedFrame = viewController.view.convert(activeField.frame, from: activeField.superview)
            let activeFieldBottom = convertedFrame.origin.y + convertedFrame.size.height
            
            let visibleArea = viewController.view.frame.size.height - keyboardHeight
            
            // If the bottom of the field is below the visible area, adjust the container position
            if activeFieldBottom > visibleArea {
                let offset = activeFieldBottom - visibleArea + 20 // Add some padding
                UIView.animate(withDuration: 0.3) {
                    containerView.transform = CGAffineTransform(translationX: 0, y: -offset)
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Reset the view position
        guard let containerView = containerView else { return }
        
        UIView.animate(withDuration: 0.3) {
            containerView.transform = .identity
        }
    }
    
    @objc private func dismissKeyboard() {
        viewController?.view.endEditing(true)
    }
    
    private func findActiveField() -> UIView? {
        guard let viewController = viewController as? InquiryPopupViewController else { return nil }
        return viewController.getActiveField()
    }
} 
