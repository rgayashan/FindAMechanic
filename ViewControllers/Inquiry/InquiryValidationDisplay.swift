//
//  InquiryValidationDisplay.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import UIKit

class InquiryValidationDisplay {
    
    // MARK: - Properties
    private weak var viewController: UIViewController?
    private var errorLabels: [UITextField: UILabel] = [:]
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Public Methods
    func setupErrorLabel(for textField: UITextField, in containerView: UIView) -> UILabel {
        let errorLabel = createErrorLabel()
        containerView.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 2),
            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 8),
            errorLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor)
        ])
        
        errorLabels[textField] = errorLabel
        return errorLabel
    }
    
    func showValidationResult(for textField: UITextField, result: (isValid: Bool, errorMessage: String?)) {
        guard let errorLabel = errorLabels[textField] else { return }
        
        errorLabel.text = result.errorMessage
        errorLabel.isHidden = result.isValid
        
        // Always show border, only change color on error
        textField.layer.borderWidth = 1
        textField.layer.borderColor = result.isValid ? UIColor.lightGray.cgColor : UIColor.red.cgColor
    }
    
    func clearAllValidationErrors() {
        for (textField, label) in errorLabels {
            label.isHidden = true
            textField.layer.borderWidth = 0
        }
    }
    
    // MARK: - Private Methods
    private func createErrorLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }
} 
