import UIKit

struct InquiryLayoutConstraints {
    static func setupContainerConstraints(container: UIView, view: UIView) {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            container.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.9)
        ])
    }
    
    static func setupHeaderConstraints(
        title: UILabel,
        closeButton: UIButton,
        container: UIView
    ) {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            
            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    static func setupFieldConstraints(
        field: UIView,
        container: UIView,
        height: CGFloat = 44
    ) {
        NSLayoutConstraint.activate([
            field.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            field.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            field.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    static func setupLabelConstraints(
        label: UILabel,
        container: UIView,
        belowView: UIView? = nil,
        topConstant: CGFloat = 16
    ) {
        var constraints = [
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ]
        
        if let belowView = belowView {
            constraints.append(label.topAnchor.constraint(equalTo: belowView.bottomAnchor, constant: topConstant))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    static func setupFieldToLabelConstraints(field: UIView, label: UILabel, spacing: CGFloat = 8) {
        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: label.bottomAnchor, constant: spacing)
        ])
    }
    
    static func setupButtonStackConstraints(
        stackView: UIStackView,
        container: UIView,
        belowView: UIView,
        height: CGFloat = 44
    ) {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: belowView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
} 