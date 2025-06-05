//
//  InquirySetupCoordinator.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import UIKit

class InquirySetupCoordinator {
    private weak var viewController: InquiryPopupViewController?
    private weak var containerView: UIView?
    
    // Handlers
    private var formHandler: InquiryFormHandler!
    private var delegateHandler: InquiryDelegateHandler!
    private var viewSetup: InquiryViewSetup!
    private var keyboardHandler: InquiryKeyboardHandler!
    private var validationDisplay: InquiryValidationDisplay!
    private var validationSetup: InquiryValidationSetup!
    
    // Form fields
    private weak var inquiryButton: UIButton?
    private weak var closeButton: UIButton?
    private weak var closeActionButton: UIButton?
    private weak var titleLabel: UILabel?
    private weak var messageTextView: UITextView?
    private weak var datePickerField: UITextField?
    private weak var vehicleRegistrationTextField: UITextField?
    private weak var nameTextField: UITextField?
    private weak var emailTextField: UITextField?
    private weak var phoneNumberTextField: UITextField?
    private weak var datePicker: UIDatePicker?
    
    init(viewController: InquiryPopupViewController, containerView: UIView, formElements: FormElements) {
        self.viewController = viewController
        self.containerView = containerView
        
        // Store form elements
        self.inquiryButton = formElements.inquiryButton
        self.closeButton = formElements.closeButton
        self.closeActionButton = formElements.closeActionButton
        self.titleLabel = formElements.titleLabel
        self.messageTextView = formElements.messageTextView
        self.datePickerField = formElements.datePickerField
        self.vehicleRegistrationTextField = formElements.vehicleRegistrationTextField
        self.nameTextField = formElements.nameTextField
        self.emailTextField = formElements.emailTextField
        self.phoneNumberTextField = formElements.phoneNumberTextField
        self.datePicker = formElements.datePicker
    }
    
    func setupAllComponents() {
        setupHandlers()
        setupUI()
        setupFieldValidation()
    }
    
    private func setupHandlers() {
        guard let viewController = viewController,
              let containerView = containerView,
              let inquiryButton = inquiryButton else { return }
        
        formHandler = InquiryFormHandler(inquiryButton: inquiryButton)
        validationDisplay = InquiryValidationDisplay(viewController: viewController)
        delegateHandler = InquiryDelegateHandler(formHandler: formHandler, viewController: viewController, validationDisplay: validationDisplay)
        validationSetup = InquiryValidationSetup(validationDisplay: validationDisplay, delegateHandler: delegateHandler)
        viewSetup = InquiryViewSetup(viewController: viewController, containerView: containerView)
        keyboardHandler = InquiryKeyboardHandler(viewController: viewController, containerView: containerView)
    }
    
    private func setupUI() {
        guard let viewController = viewController,
              let containerView = containerView,
              let titleLabel = titleLabel,
              let closeButton = closeButton,
              let messageTextView = messageTextView,
              let inquiryButton = inquiryButton,
              let closeActionButton = closeActionButton,
              let datePicker = datePicker,
              let datePickerField = datePickerField else { return }
        
        // Setup base view
        viewSetup.setupBaseView()
        InquiryLayoutConstraints.setupContainerConstraints(container: containerView, view: viewController.view)
        
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
        
        // Setup date picker
        setupDatePicker(datePicker, forField: datePickerField)
    }
    
    private func getFieldsConfig() -> [(UITextField, String)] {
        guard let vehicleRegistrationTextField = vehicleRegistrationTextField,
              let nameTextField = nameTextField,
              let emailTextField = emailTextField,
              let phoneNumberTextField = phoneNumberTextField,
              let datePickerField = datePickerField else { return [] }
        
        return [
            (vehicleRegistrationTextField, "Vehicle Registration No"),
            (nameTextField, "Name"),
            (emailTextField, "Email address"),
            (phoneNumberTextField, "Phone Number"),
            (datePickerField, "Select Date")
        ]
    }
    
    private func setupFieldValidation() {
        guard let containerView = containerView,
              let vehicleRegistrationTextField = vehicleRegistrationTextField,
              let nameTextField = nameTextField,
              let emailTextField = emailTextField,
              let phoneNumberTextField = phoneNumberTextField else { return }
        
        validationSetup.setupValidation(
            containerView: containerView,
            vehicleRegistrationTextField: vehicleRegistrationTextField,
            nameTextField: nameTextField,
            emailTextField: emailTextField,
            phoneNumberTextField: phoneNumberTextField
        )
    }
    
    private func setupActionsAndDelegates() {
        guard let viewController = viewController,
              let vehicleRegistrationTextField = vehicleRegistrationTextField,
              let nameTextField = nameTextField,
              let emailTextField = emailTextField,
              let phoneNumberTextField = phoneNumberTextField,
              let messageTextView = messageTextView,
              let closeButton = closeButton,
              let closeActionButton = closeActionButton,
              let inquiryButton = inquiryButton else { return }
        
        // Setup text field delegates
        let textFields = [vehicleRegistrationTextField, nameTextField, emailTextField, phoneNumberTextField]
        delegateHandler.setupTextFieldActions(fields: textFields, target: viewController, action: #selector(InquiryPopupViewController.textFieldDidChange(_:)))
        
        // Setup text view delegate
        messageTextView.delegate = delegateHandler
        
        // Setup button actions
        closeButton.addTarget(viewController, action: #selector(InquiryPopupViewController.closeButtonTapped), for: .touchUpInside)
        closeActionButton.addTarget(viewController, action: #selector(InquiryPopupViewController.closeButtonTapped), for: .touchUpInside)
        inquiryButton.addTarget(viewController, action: #selector(InquiryPopupViewController.inquiryButtonTapped), for: .touchUpInside)
    }
    
    private func setupDatePicker(_ datePicker: UIDatePicker, forField datePickerField: UITextField) {
        guard let viewController = viewController else { return }
        
        // Ensure date-only mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        // Set a date formatter to ensure only date is handled
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none  // Explicitly no time
        
        let toolbar = InquiryUIFactory.createDatePickerToolbar(
            doneTarget: viewController, doneAction: #selector(InquiryPopupViewController.datePickerDone),
            cancelTarget: viewController, cancelAction: #selector(InquiryPopupViewController.datePickerCancel)
        )
        
        datePickerField.inputView = datePicker
        datePickerField.inputAccessoryView = toolbar
        
        // Set initial date display
//        datePickerField.text = dateFormatter.string(from: datePicker.date)
    }
    
    // Public methods for controller to use
    func validateAllFields() -> Bool {
        guard let emailTextField = emailTextField,
              let phoneNumberTextField = phoneNumberTextField else { return false }
        
        return validationSetup.validateAllFields(
            formHandler: formHandler,
            emailTextField: emailTextField,
            phoneNumberTextField: phoneNumberTextField
        )
    }
    
    func updateFormData() {
        guard let vehicleRegistrationTextField = vehicleRegistrationTextField,
              let nameTextField = nameTextField,
              let emailTextField = emailTextField,
              let phoneNumberTextField = phoneNumberTextField,
              let messageTextView = messageTextView else { return }
        
        formHandler.updateFormData(
            vehicleRegistration: vehicleRegistrationTextField.text,
            name: nameTextField.text,
            email: emailTextField.text,
            phoneNumber: phoneNumberTextField.text,
            message: messageTextView.text
        )
    }
    
    func updateDatePickerField() {
        guard let datePickerField = datePickerField,
              let datePicker = datePicker else { return }
        
        datePickerField.text = formHandler.formatDate(date: datePicker.date)
        formHandler.updateDate(date: datePicker.date)
    }
    
    func getInquiryForm() -> InquiryForm {
        return formHandler.getInquiryForm()
    }
}

// Structure to hold all form elements
struct FormElements {
    let inquiryButton: UIButton
    let closeButton: UIButton
    let closeActionButton: UIButton
    let titleLabel: UILabel
    let messageTextView: UITextView
    let datePickerField: UITextField
    let vehicleRegistrationTextField: UITextField
    let nameTextField: UITextField
    let emailTextField: UITextField
    let phoneNumberTextField: UITextField
    let datePicker: UIDatePicker
} 
