//
//  InquiryUIFactory.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import UIKit

struct InquiryUIFactory {
    static func createContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func createTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 20)  
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createCloseButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .darkGray
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }
    
    static func createMessageTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.textColor = .darkGray
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        return textView
    }
    
    static func createButton(title: String, backgroundColor: UIColor, isEnabled: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = isEnabled
        button.alpha = isEnabled ? 1.0 : 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func createFieldLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createButtonStackView(buttons: [UIButton], spacing: CGFloat = 10) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        return datePicker
    }
    
    static func createDatePickerToolbar(doneTarget: Any?, doneAction: Selector, cancelTarget: Any?, cancelAction: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: doneTarget, action: doneAction)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: cancelTarget, action: cancelAction)
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        return toolbar
    }
    
    
} 
