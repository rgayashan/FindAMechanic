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
    private var formHandler: InquiryFormHandler!
    private var delegateHandler: InquiryDelegateHandler!
    private var viewSetup: InquiryViewSetup!
    private var keyboardHandler: InquiryKeyboardHandler!
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
        
        // Initialize handlers
        formHandler = InquiryFormHandler(inquiryButton: inquiryButton)
        delegateHandler = InquiryDelegateHandler(formHandler: formHandler, viewController: self)
        viewSetup = InquiryViewSetup(viewController: self, containerView: containerView)
        keyboardHandler = InquiryKeyboardHandler(viewController: self, containerView: containerView)
        
        // Setup UI
        setupUIComponents()
    }
    
    private func setupUIComponents() {
        // Base view and container setup
        viewSetup.setupBaseView()
        InquiryLayoutConstraints.setupContainerConstraints(container: containerView, view: view)
        
        // Configure and setup fields
        viewSetup.setupFields(
            titleLabel: titleLabel,
            closeButton: closeButton,
            fields: getFieldsConfig(),
            messageTextView: messageTextView,
            buttons: [inquiryButton, closeActionButton]
        )
        
        // Setup actions and delegates
        setupActionsAndDelegates()
        setupDatePicker()
    }
    
    private func getFieldsConfig() -> [(UITextField, String)] {
        return [
            (vehicleRegistrationTextField, "Vehicle Registration No"),
            (nameTextField, "Name"),
            (emailTextField, "Email address"),
            (phoneNumberTextField, "Phone Number"),
            (datePickerField, "Select Date")
        ]
    }
    
    private func setupActionsAndDelegates() {
        // Setup text field delegates
        let textFields = [vehicleRegistrationTextField, nameTextField, emailTextField, phoneNumberTextField]
        delegateHandler.setupTextFieldActions(fields: textFields, target: self, action: #selector(textFieldDidChange(_:)))
        
        // Setup text view delegate and button actions
        messageTextView.delegate = delegateHandler
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeActionButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        inquiryButton.addTarget(self, action: #selector(inquiryButtonTapped), for: .touchUpInside)
    }
    
    private func setupDatePicker() {
        datePicker = InquiryUIFactory.createDatePicker()
        let toolbar = InquiryUIFactory.createDatePickerToolbar(
            doneTarget: self, doneAction: #selector(datePickerDone),
            cancelTarget: self, cancelAction: #selector(datePickerCancel)
        )
        datePickerField.inputView = datePicker
        datePickerField.inputAccessoryView = toolbar
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() { dismiss(animated: true) }
    
    @objc private func inquiryButtonTapped() {
        let alert = InquiryUIFactory.createConfirmationAlert(
            title: "Confirm Inquiry",
            message: "Would you like to submit this inquiry to the mechanic?",
            cancelAction: {},
            confirmAction: { [weak self] in
                guard let self = self else { return }
                self.delegate?.inquirySubmitted(inquiry: self.formHandler.getInquiryForm())
                self.dismiss(animated: true)
            }
        )
        present(alert, animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) { updateFormData() }
    
    @objc private func datePickerDone() {
        datePickerField.text = formHandler.formatDate(date: datePicker.date)
        formHandler.updateDate(date: datePicker.date)
        view.endEditing(true)
    }
    
    @objc private func datePickerCancel() { view.endEditing(true) }
    
    // MARK: - Public Helpers
    func updateFormData() {
        formHandler.updateFormData(
            vehicleRegistration: vehicleRegistrationTextField.text,
            name: nameTextField.text,
            email: emailTextField.text,
            phoneNumber: phoneNumberTextField.text,
            message: messageTextView.text
        )
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
