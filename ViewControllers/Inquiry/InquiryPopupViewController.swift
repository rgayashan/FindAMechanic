//
//  InquiryPopupViewController.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import UIKit
import Foundation

protocol InquiryPopupDelegate: AnyObject {
    func inquirySubmitted(inquiry: InquiryForm)
}

class InquiryPopupViewController: BaseViewController {
    
    // MARK: - Properties
    var mechanicName: String?
    private var setupCoordinator: InquirySetupCoordinator!
    private var datePicker = UIDatePicker()
    weak var delegate: InquiryPopupDelegate?
    var tenantId: Int = 0
    
    // MARK: - UI Elements
    private let containerView = InquiryUIFactory.createContainerView()
    private var titleLabel: UILabel!
    private let closeButton = InquiryUIFactory.createCloseButton()
    private let vehicleRegistrationTextField = InquiryUIFactory.createTextField(placeholder: "Enter Vehicle Registration No")
    private let nameTextField = InquiryUIFactory.createTextField(placeholder: "Enter Name")
    private let emailTextField = InquiryUIFactory.createTextField(placeholder: "Enter Email", keyboardType: .emailAddress)
    private let phoneNumberTextField = InquiryUIFactory.createTextField(placeholder: "Enter Phone Number", keyboardType: .phonePad)
    private let datePickerField = InquiryUIFactory.createTextField(placeholder: "Select Date")
    private let messageTextView = InquiryUIFactory.createMessageTextView()
    private lazy var inquiryButton = InquiryUIFactory.createButton(title: "Inquiry", backgroundColor: UIColor(named: "theme-bg") ?? .systemBlue, isEnabled: false)
    private lazy var closeActionButton = InquiryUIFactory.createButton(title: "Close", backgroundColor: .systemGray)
    
    // MARK: - Lifecycle & Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use mechanicName for the title label
        let displayName = mechanicName ?? "Mechanic"
        titleLabel = InquiryUIFactory.createTitleLabel(title: displayName)
        
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
        
        let alert = self.confirmationAlert(
            title: "Confirm Inquiry",
            message: "Would you like to submit this inquiry to the mechanic?",
            cancelAction: {},
            confirmAction: { [weak self] in
                guard let self = self else { return }
                let inquiry = self.setupCoordinator.getInquiryForm()
                self.submitInquiry(inquiry: inquiry)
            },
            cancelText: "Cancel",
            confirmText: "Submit"
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
    
    
    private func submitInquiry(inquiry: InquiryForm) {
        let dateFormatter = ISO8601DateFormatter()
        let dateString = dateFormatter.string(from: inquiry.date!)
        
        let payload: [String: Any] = [
            "tenantId": self.tenantId,
            "vehicleRegistrationNumber": inquiry.vehicleRegistration,
            "RequestedDate": dateString,
            "PlanStartDate": dateString,
            "PlanEndDate": dateString,
            "DropOffDate": dateString,
            "PickUpDate": dateString,
            "CustomerName": inquiry.name,
            "CustomerContactName": inquiry.phoneNumber,
            "CustomerEmail": inquiry.email,
            "CustomerPhone": inquiry.phoneNumber,
            "Notes": inquiry.message,
            "Status": "50",
            "ObjectId": "BOKING",
            "Channel": "02"
        ]
        
        // Show loading toast
        DispatchQueue.main.async {
            self.showToast(message: "Submitting inquiry...")
        }
        
        Task {
            do {
                let _: EmptyResponse = try await APIService.shared.post(
                    endpoint: APIEndpoints.Bookings.create,
                    body: payload
                )
                
                DispatchQueue.main.async {
                    self.delegate?.inquirySubmitted(inquiry: inquiry)
                    self.showToast(message: "Success! Your inquiry has been submitted", dismissPopupAfter: true)
                }
            } catch {
                let errorMessage: String
                if let apiError = error as? APIError {
                    switch apiError {
                    case .unauthorized:
                        errorMessage = "Authentication failed"
                    case .serverError(let code):
                        errorMessage = "Server error (Status: \(code))"
                    default:
                        errorMessage = apiError.localizedDescription
                    }
                } else {
                    errorMessage = "Failed to submit inquiry: \(error.localizedDescription)"
                }
                
                DispatchQueue.main.async {
                    self.showToast(message: errorMessage)
                }
            }
        }
    }
}
