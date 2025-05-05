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
    private var inquiryForm = InquiryForm()
    private let datePicker = UIDatePicker()
    weak var delegate: InquiryPopupDelegate?
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Celtic Car Sound"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let vehicleRegistrationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Vehicle Registration No"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Phone Number"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let datePickerField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select Date"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let inquiryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Inquiry", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let closeActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
        setupDatePicker()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        
        containerView.addSubview(vehicleRegistrationTextField)
        containerView.addSubview(nameTextField)
        containerView.addSubview(emailTextField)
        containerView.addSubview(phoneNumberTextField)
        containerView.addSubview(datePickerField)
        containerView.addSubview(messageTextView)
        
        let buttonStackView = UIStackView(arrangedSubviews: [inquiryButton, closeActionButton])
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(buttonStackView)
        
        // Add labels for each field
        let registrationLabel = createLabel(text: "Vehicle Registration No")
        let nameLabel = createLabel(text: "Name")
        let emailLabel = createLabel(text: "Email address")
        let phoneLabel = createLabel(text: "Phone Number")
        let dateLabel = createLabel(text: "Select Date")
        let messageLabel = createLabel(text: "Message to mechanic")
        
        containerView.addSubview(registrationLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(emailLabel)
        containerView.addSubview(phoneLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(messageLabel)
        
        // Setup constraints for labels
        NSLayoutConstraint.activate([
            registrationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            registrationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            registrationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            vehicleRegistrationTextField.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 8),
            
            nameLabel.topAnchor.constraint(equalTo: vehicleRegistrationTextField.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            
            phoneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            phoneLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            phoneLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            
            dateLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            datePickerField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            
            messageLabel.topAnchor.constraint(equalTo: datePickerField.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            messageTextView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            
            buttonStackView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.9),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            vehicleRegistrationTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            vehicleRegistrationTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            vehicleRegistrationTextField.heightAnchor.constraint(equalToConstant: 44),
            
            nameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            phoneNumberTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 44),
            
            datePickerField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            datePickerField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            datePickerField.heightAnchor.constraint(equalToConstant: 44),
            
            messageTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupActions() {
        // Add targets for text fields
        vehicleRegistrationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Setup delegates
        vehicleRegistrationTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        messageTextView.delegate = self
        
        // Add button actions
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeActionButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        inquiryButton.addTarget(self, action: #selector(inquiryButtonTapped), for: .touchUpInside)
    }
    
    private func setupDatePicker() {
        // Configure date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        
        // Configure toolbar for date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(datePickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(datePickerCancel))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        datePickerField.inputView = datePicker
        datePickerField.inputAccessoryView = toolbar
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func inquiryButtonTapped() {
        // Show confirmation alert
        let alert = UIAlertController(
            title: "Confirm Inquiry",
            message: "Would you like to submit this inquiry to the mechanic?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.inquirySubmitted(inquiry: self.inquiryForm)
            self.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateFormData()
        updateInquiryButtonState()
    }
    
    @objc private func datePickerDone() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        datePickerField.text = formatter.string(from: datePicker.date)
        inquiryForm.date = datePicker.date
        updateInquiryButtonState()
        view.endEditing(true)
    }
    
    @objc private func datePickerCancel() {
        view.endEditing(true)
    }
    
    // MARK: - Helpers
    private func updateFormData() {
        inquiryForm.vehicleRegistration = vehicleRegistrationTextField.text ?? ""
        inquiryForm.name = nameTextField.text ?? ""
        inquiryForm.email = emailTextField.text ?? ""
        inquiryForm.phoneNumber = phoneNumberTextField.text ?? ""
        inquiryForm.message = messageTextView.text ?? ""
    }
    
    private func updateInquiryButtonState() {
        let isFormValid = inquiryForm.isValid
        inquiryButton.isEnabled = isFormValid
        inquiryButton.alpha = isFormValid ? 1.0 : 0.5
    }
}

// MARK: - UITextFieldDelegate
extension InquiryPopupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateFormData()
        updateInquiryButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension InquiryPopupViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        inquiryForm.message = textView.text
        updateInquiryButtonState()
    }
}
