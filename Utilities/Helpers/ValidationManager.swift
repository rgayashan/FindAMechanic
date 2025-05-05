import UIKit

/// A utility class for handling common form validations
class ValidationManager {
    
    struct ValidationError {
        let field: UIView
        let message: String
    }
    
    // MARK: - Validation Methods
    
    /// Validates if an email string has valid format
    /// - Parameter email: The email string to validate
    /// - Returns: true if valid, false otherwise
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Validates if a phone number string has valid format
    /// - Parameter phone: The phone number string to validate
    /// - Returns: true if valid, false otherwise
    static func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{10,15}$" // Adjust regex as needed for your requirements
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    /// Validates if a string is not empty
    /// - Parameter text: The string to validate
    /// - Returns: true if not empty, false otherwise
    static func isNotEmpty(_ text: String?) -> Bool {
        guard let text = text else { return false }
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Visual Feedback
    
    /// Highlights a text field to indicate validation error
    /// - Parameter textField: The text field to highlight
    static func showErrorForTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.red.cgColor
        
        // Animate the error state
        UIView.animate(withDuration: 0.1, animations: {
            textField.transform = CGAffineTransform(translationX: 10, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                textField.transform = CGAffineTransform(translationX: -10, y: 0)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    textField.transform = CGAffineTransform.identity
                })
            })
        })
    }
    
    /// Resets the appearance of a text field to normal state
    /// - Parameter textField: The text field to reset
    static func resetTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    /// Shows validation error message label below a field
    /// - Parameters:
    ///   - message: Error message to display
    ///   - field: The field associated with the error
    ///   - errorLabel: The label to display the error
    static func showError(message: String, for field: UIView, in errorLabel: UILabel) {
        errorLabel.text = message
        errorLabel.textColor = .red
        errorLabel.isHidden = false
        
        // Highlight the field
        if let textField = field as? UITextField {
            showErrorForTextField(textField)
        } else if let textView = field as? UITextView {
            textView.layer.borderColor = UIColor.red.cgColor
            textView.layer.borderWidth = 1.0
        }
    }
    
    /// Hides error message and resets field appearance
    /// - Parameters:
    ///   - field: The field to reset
    ///   - errorLabel: The error label to hide
    static func hideError(for field: UIView, in errorLabel: UILabel) {
        errorLabel.isHidden = true
        
        // Reset field appearance
        if let textField = field as? UITextField {
            resetTextField(textField)
        } else if let textView = field as? UITextView {
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = 0.5
        }
    }
} 