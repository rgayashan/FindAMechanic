import UIKit

class InquiryFormHandler {
    private var inquiryForm: InquiryForm
    private weak var inquiryButton: UIButton?
    
    init(inquiryForm: InquiryForm = InquiryForm(), inquiryButton: UIButton? = nil) {
        self.inquiryForm = inquiryForm
        self.inquiryButton = inquiryButton
    }
    
    func updateFormData(
        vehicleRegistration: String?,
        name: String?,
        email: String?,
        phoneNumber: String?,
        message: String?
    ) {
        inquiryForm.vehicleRegistration = vehicleRegistration ?? ""
        inquiryForm.name = name ?? ""
        inquiryForm.email = email ?? ""
        inquiryForm.phoneNumber = phoneNumber ?? ""
        if let message = message {
            inquiryForm.message = message
        }
        
        updateInquiryButtonState()
    }
    
    func updateDate(date: Date) {
        inquiryForm.date = date
        updateInquiryButtonState()
    }
    
    func updateMessage(message: String) {
        inquiryForm.message = message
        updateInquiryButtonState()
    }
    
    private func updateInquiryButtonState() {
        let isFormValid = inquiryForm.isValid && isValidEmail(inquiryForm.email) && isValidPhoneNumber(inquiryForm.phoneNumber)
        inquiryButton?.isEnabled = isFormValid
        inquiryButton?.alpha = isFormValid ? 1.0 : 0.5
    }
    
    func getInquiryForm() -> InquiryForm {
        return inquiryForm
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // MARK: - Validation Methods
    
    func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        guard !phoneNumber.isEmpty else { return false }
        
        // Allow phone numbers in these formats:
        // - 10 digits (1234567890)
        // - With optional country code (+1 1234567890 or +94 1234567890)
        // - With optional separators (+94-123-456-7890 or +94 123 456 7890)
        let phoneRegex = "^(\\+\\d{1,3}[- ]?)?\\d{3}[- ]?\\d{3}[- ]?\\d{4}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    func validateField(type: ValidationFieldType, text: String) -> (isValid: Bool, errorMessage: String?) {
        switch type {
        case .email:
            let isValid = isValidEmail(text)
            return (isValid, isValid ? nil : "Please enter a valid email address")
            
        case .phoneNumber:
            let isValid = isValidPhoneNumber(text)
            return (isValid, isValid ? nil : "Please enter a valid phone number")
            
        case .required:
            let isValid = !text.isEmpty
            return (isValid, isValid ? nil : "This field is required")
            
        case .none:
            return (true, nil)
        }
    }
}

enum ValidationFieldType {
    case email
    case phoneNumber
    case required
    case none
} 