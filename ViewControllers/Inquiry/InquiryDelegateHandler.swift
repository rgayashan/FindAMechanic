import UIKit

class InquiryDelegateHandler: NSObject {
    private let formHandler: InquiryFormHandler
    private weak var viewController: UIViewController?
    
    init(formHandler: InquiryFormHandler, viewController: UIViewController? = nil) {
        self.formHandler = formHandler
        self.viewController = viewController
    }
    
    // Helper method to setup targets and delegates
    func setupTextFieldActions(
        fields: [UITextField],
        target: Any?,
        action: Selector
    ) {
        fields.forEach { field in
            field.addTarget(target, action: action, for: .editingChanged)
            field.delegate = self
        }
    }
}

// MARK: - UITextFieldDelegate
extension InquiryDelegateHandler: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let vc = viewController as? InquiryPopupViewController else { return }
        vc.updateFormData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension InquiryDelegateHandler: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        formHandler.updateMessage(message: textView.text)
    }
} 