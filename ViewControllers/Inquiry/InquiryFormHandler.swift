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
        let isFormValid = inquiryForm.isValid
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
} 