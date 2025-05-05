import UIKit

class InquiryValidationSetup {
    private let validationDisplay: InquiryValidationDisplay
    private let delegateHandler: InquiryDelegateHandler
    
    init(validationDisplay: InquiryValidationDisplay, delegateHandler: InquiryDelegateHandler) {
        self.validationDisplay = validationDisplay
        self.delegateHandler = delegateHandler
    }
    
    func setupValidation(
        containerView: UIView,
        vehicleRegistrationTextField: UITextField,
        nameTextField: UITextField,
        emailTextField: UITextField,
        phoneNumberTextField: UITextField
    ) {
        // Setup validation error labels
        validationDisplay.setupErrorLabel(for: vehicleRegistrationTextField, in: containerView)
        validationDisplay.setupErrorLabel(for: nameTextField, in: containerView)
        validationDisplay.setupErrorLabel(for: emailTextField, in: containerView)
        validationDisplay.setupErrorLabel(for: phoneNumberTextField, in: containerView)
        
        // Set validation types for fields
        delegateHandler.setValidationType(for: vehicleRegistrationTextField, type: .required)
        delegateHandler.setValidationType(for: nameTextField, type: .required)
        delegateHandler.setValidationType(for: emailTextField, type: .email)
        delegateHandler.setValidationType(for: phoneNumberTextField, type: .phoneNumber)
    }
    
    func validateAllFields(
        formHandler: InquiryFormHandler,
        emailTextField: UITextField,
        phoneNumberTextField: UITextField
    ) -> Bool {
        let emailResult = formHandler.validateField(type: .email, text: emailTextField.text ?? "")
        let phoneResult = formHandler.validateField(type: .phoneNumber, text: phoneNumberTextField.text ?? "")
        
        let isValid = emailResult.isValid && phoneResult.isValid
        
        if !isValid {
            validationDisplay.showValidationResult(for: emailTextField, result: emailResult)
            validationDisplay.showValidationResult(for: phoneNumberTextField, result: phoneResult)
        }
        
        return isValid
    }
} 