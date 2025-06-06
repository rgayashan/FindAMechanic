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

class InquiryPopupViewController: UIViewController {
    
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
    private lazy var inquiryButton = InquiryUIFactory.createButton(title: "Inquiry", backgroundColor: .systemBlue, isEnabled: false)
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
        
        let alert = InquiryUIFactory.createConfirmationAlert(
            title: "Confirm Inquiry",
            message: "Would you like to submit this inquiry to the mechanic?",
            cancelAction: {},
            confirmAction: { [weak self] in
                guard let self = self else { return }
                let inquiry = self.setupCoordinator.getInquiryForm()
                self.submitInquiry(inquiry: inquiry)
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
    
    private func showToast(message: String, dismissPopupAfter: Bool = false) {
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
    
    private func submitInquiry(inquiry: InquiryForm) {
        let baseURL = APIConstants.baseURL
        guard let url = URL(string: "\(baseURL)/api/bookings") else {
            showToast(message: "Invalid URL configuration")
            return 
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: .fragmentsAllowed)
        } catch {
            DispatchQueue.main.async {
                self.showToast(message: "Failed to process your request. Please try again.")
            }
            return
        }
        
        // Show loading toast
        DispatchQueue.main.async {
            self.showToast(message: "Submitting inquiry...")
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.showToast(message: "Network error: Please check your connection")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showToast(message: "Invalid server response")
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    self.delegate?.inquirySubmitted(inquiry: inquiry)
                    // Show success toast and dismiss after it completes
                    self.showToast(message: "Success! Your inquiry has been submitted", dismissPopupAfter: true)
                case 400:
                    self.showToast(message: "Invalid request. Please check your details")
                case 401:
                    self.showToast(message: "Authentication failed")
                case 500:
                    self.showToast(message: "Server error. Please try again later")
                default:
                    self.showToast(message: "Error: Unable to submit inquiry (Status: \(httpResponse.statusCode))")
                }
            }
        }
        
        task.resume()
    }
}
