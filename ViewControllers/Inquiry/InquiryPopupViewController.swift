//
//  InquiryPopupViewController.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import UIKit

protocol InquiryPopupDelegate: AnyObject {
    func inquirySubmitted(inquiry: InquiryForm)
}

class InquiryPopupViewController: UIViewController {
    
    // MARK: - Properties
    private var setupCoordinator: InquirySetupCoordinator!
    private var datePicker = UIDatePicker()
    weak var delegate: InquiryPopupDelegate?
    
    // MARK: - UI Elements
    private let containerView = InquiryUIFactory.createContainerView()
    private let titleLabel = InquiryUIFactory.createTitleLabel(title: "Celtic Car Sound")
    private let closeButton = InquiryUIFactory.createCloseButton()
    private let vehicleRegistrationTextField = InquiryUIFactory.createTextField(placeholder: "Enter Vehicle Registration No")
    private let nameTextField = InquiryUIFactory.createTextField(placeholder: "Enter Name")
    private let emailTextField = InquiryUIFactory.createTextField(placeholder: "Enter Email", keyboardType: .emailAddress)
    private let phoneNumberTextField = InquiryUIFactory.createTextField(placeholder: "Enter Phone Number", keyboardType: .phonePad)
    private let datePickerField = InquiryUIFactory.createTextField(placeholder: "Select Date")
    private let messageTextView = InquiryUIFactory.createMessageTextView()
    private lazy var inquiryButton = InquiryUIFactory.createButton(title: "Inquiry", backgroundColor: .systemBlue, isEnabled: false)
    private lazy var closeActionButton = InquiryUIFactory.createButton(title: "Close", backgroundColor: .systemGray)
    
    // MARK: - Lifecycle & Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create form elements
        let formElements = FormElements(
            inquiryButton: inquiryButton,
            closeButton: closeButton,
            closeActionButton: closeActionButton,
            titleLabel: titleLabel,
            messageTextView: messageTextView,
            datePickerField: datePickerField,
            vehicleRegistrationTextField: vehicleRegistrationTextField,
            nameTextField: nameTextField,
            emailTextField: emailTextField,
            phoneNumberTextField: phoneNumberTextField,
            datePicker: datePicker
        )
        
        // Initialize coordinator
        setupCoordinator = InquirySetupCoordinator(
            viewController: self,
            containerView: containerView,
            formElements: formElements
        )
        
        // Setup UI components
        setupCoordinator.setupAllComponents()
    }
    
    // MARK: - Actions
    @objc func closeButtonTapped() { dismiss(animated: true) }
    
    @objc func inquiryButtonTapped() {
        // Validate all fields before submitting
        if !setupCoordinator.validateAllFields() {
            return
        }
        
        let alert = InquiryUIFactory.createConfirmationAlert(
            title: "Confirm Inquiry",
            message: "Would you like to submit this inquiry to the mechanic?",
            cancelAction: {},
            confirmAction: { [weak self] in
                guard let self = self else { return }
                self.delegate?.inquirySubmitted(inquiry: self.setupCoordinator.getInquiryForm())
                self.dismiss(animated: true)
            }
        )
        present(alert, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) { updateFormData() }
    
    @objc func datePickerDone() {
        setupCoordinator.updateDatePickerField()
        view.endEditing(true)
    }
    
    @objc func datePickerCancel() { view.endEditing(true) }
    
    // MARK: - Public Helpers
    func updateFormData() {
        setupCoordinator.updateFormData()
    }
    
    func getActiveField() -> UIView? {
        if messageTextView.isFirstResponder { return messageTextView }
        else if vehicleRegistrationTextField.isFirstResponder { return vehicleRegistrationTextField }
        else if nameTextField.isFirstResponder { return nameTextField }
        else if emailTextField.isFirstResponder { return emailTextField }
        else if phoneNumberTextField.isFirstResponder { return phoneNumberTextField }
        else if datePickerField.isFirstResponder { return datePickerField }
        return nil
    }
}
