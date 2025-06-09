//
//  InquiryDelegateHandler.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

class InquiryDelegateHandler: NSObject {
    private let formHandler: InquiryFormHandler
    private weak var viewController: UIViewController?
    private var validationDisplay: InquiryValidationDisplay?
    private var fieldValidationTypes: [UITextField: ValidationFieldType] = [:]
    
    init(formHandler: InquiryFormHandler, viewController: UIViewController? = nil, validationDisplay: InquiryValidationDisplay? = nil) {
        self.formHandler = formHandler
        self.viewController = viewController
        self.validationDisplay = validationDisplay
        super.init()
    }
    
    // Helper method to setup targets and delegates
    func setupTextFieldActions(
        fields: [UITextField],
        target: Any?,
        action: Selector
    ) {
        fields.forEach { field in
            field.addTarget(target, action: action, for: .editingChanged)
            field.delegate = self
        }
    }
    
    func setValidationType(for textField: UITextField, type: ValidationFieldType) {
        fieldValidationTypes[textField] = type
    }
    
    private func validateTextField(_ textField: UITextField) {
        guard let validationType = fieldValidationTypes[textField] else { return }
        
        let result = formHandler.validateField(type: validationType, text: textField.text ?? "")
        validationDisplay?.showValidationResult(for: textField, result: result)
    }
}

// MARK: - UITextFieldDelegate
extension InquiryDelegateHandler: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let vc = viewController as? InquiryPopupViewController else { return }
        vc.updateFormData()
        validateTextField(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Clear validation error when starting to edit
        if fieldValidationTypes[textField] != nil {
            validationDisplay?.showValidationResult(for: textField, result: (isValid: true, errorMessage: nil))
        }
    }
}

// MARK: - UITextViewDelegate
extension InquiryDelegateHandler: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        formHandler.updateMessage(message: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // This will ensure keyboard notifications are triggered
        // The keyboard will show and the container will adjust position
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // Ensure the view scrolls up when this text view becomes active
        return true
    }
} 
