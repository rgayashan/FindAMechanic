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
    
    private func submitInquiry(inquiry: InquiryForm) {
        let baseURL = APIConstants.baseURL
        guard let url = URL(string: "\(baseURL)/api/bookings1/inquiry") else { return }
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
            showToast(message: "Failed to encode request.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.showToast(message: "Error: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.showToast(message: "Server error.")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.showToast(message: "Success! Booking request was submitted.")
            }
        }
        
        task.resume()
    }
    
    private func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
