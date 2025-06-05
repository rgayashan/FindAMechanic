//
//  InquiryViewSetup.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import UIKit

class InquiryViewSetup {
    private weak var viewController: UIViewController?
    private weak var containerView: UIView?
    
    init(viewController: UIViewController, containerView: UIView) {
        self.viewController = viewController
        self.containerView = containerView
    }
    
    func setupBaseView() {
        guard let view = viewController?.view, let containerView = containerView else { return }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(containerView)
    }
    
    func setupFields(
        titleLabel: UILabel,
        closeButton: UIButton,
        fields: [(UITextField, String)],
        messageTextView: UITextView,
        buttons: [UIButton]
    ) {
        guard let containerView = containerView else { return }
        
        // Add header elements
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        
        // Setup constraints for header
        InquiryLayoutConstraints.setupHeaderConstraints(
            title: titleLabel,
            closeButton: closeButton,
            container: containerView
        )
        
        // Add and configure text fields
        var previousView: UIView = titleLabel
        
        for (field, labelText) in fields {
            let label = InquiryUIFactory.createFieldLabel(text: labelText)
            containerView.addSubview(label)
            containerView.addSubview(field)
            
            InquiryLayoutConstraints.setupLabelConstraints(
                label: label,
                container: containerView,
                belowView: previousView
            )
            
            InquiryLayoutConstraints.setupFieldToLabelConstraints(
                field: field,
                label: label
            )
            
            InquiryLayoutConstraints.setupFieldConstraints(
                field: field,
                container: containerView
            )
            
            previousView = field
        }
        
        // Add message text view
        let messageLabel = InquiryUIFactory.createFieldLabel(text: "Message to mechanic")
        containerView.addSubview(messageLabel)
        containerView.addSubview(messageTextView)
        
        InquiryLayoutConstraints.setupLabelConstraints(
            label: messageLabel,
            container: containerView,
            belowView: previousView
        )
        
        InquiryLayoutConstraints.setupFieldToLabelConstraints(
            field: messageTextView,
            label: messageLabel
        )
        
        InquiryLayoutConstraints.setupFieldConstraints(
            field: messageTextView,
            container: containerView,
            height: 100
        )
        
        // Add buttons
        let buttonStackView = InquiryUIFactory.createButtonStackView(buttons: buttons)
        containerView.addSubview(buttonStackView)
        
        InquiryLayoutConstraints.setupButtonStackConstraints(
            stackView: buttonStackView,
            container: containerView,
            belowView: messageTextView
        )
    }
} 
