//
//  MachanicTableViewCell.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//
//

import UIKit

class MechanicTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var mechanic: Mechanic?
    weak var delegate: MechanicTableViewCellDelegate?
    
    // MARK: - UI Components
    private let containerView = MechanicCellComponents.createContainerView()
    private let logoImageView = MechanicCellComponents.createLogoImageView()
    private let nameLabel = MechanicCellComponents.createNameLabel()
    private let addressLine1Label = MechanicCellComponents.createAddressLabel()
    private let addressLine2Label = MechanicCellComponents.createAddressLabel()
    private let phoneLabel = MechanicCellComponents.createPhoneLabel()
    private let bookButton = MechanicCellComponents.createBookButton()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(containerView)
        [logoImageView, nameLabel, addressLine1Label, addressLine2Label, phoneLabel, bookButton]
            .forEach(containerView.addSubview)
        
        bookButton.addTarget(self, action: #selector(bookButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Logo constraints
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            logoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Address Line 1 constraints
            addressLine1Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            addressLine1Label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLine1Label.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Address Line 2 constraints
            addressLine2Label.topAnchor.constraint(equalTo: addressLine1Label.bottomAnchor, constant: 2),
            addressLine2Label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLine2Label.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Phone constraints
            phoneLabel.topAnchor.constraint(equalTo: addressLine2Label.bottomAnchor, constant: 4),
            phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Book button constraints
            bookButton.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            bookButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            bookButton.heightAnchor.constraint(equalToConstant: 36),
            bookButton.widthAnchor.constraint(equalToConstant: 140),
            bookButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration Methods
    func configure(with mechanic: Mechanic) {
        self.mechanic = mechanic
        nameLabel.text = mechanic.name
        addressLine1Label.text = mechanic.addressLine1
        addressLine2Label.text = mechanic.addressLine2
        // phoneLabel.text = "Phone: \(mechanic.phone)"
        
        if let logoUrl = mechanic.logoUrl {
            loadImage(from: logoUrl)
        } else {
            logoImageView.image = UIImage(named: "placeholder")
        }
        
        // Apply initial animations
        MechanicCellAnimator.applyAppearAnimation(to: self, containerView: containerView)
        MechanicCellAnimator.applyBookButtonAnimation(to: bookButton)
    }
    
    private func loadImage(from urlString: String) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [weak self] in
                    self?.logoImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    // MARK: - Highlight Handling
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        MechanicCellAnimator.applyHighlightAnimation(to: containerView, isHighlighted: highlighted)
    }
    
    // MARK: - Actions
    @objc private func bookButtonTapped() {
        guard let mechanic = self.mechanic else { return }
        MechanicCellAnimator.applyTapAnimation(to: bookButton) { [weak self] in
            self?.delegate?.didTapBookButton(for: mechanic)
        }
    }
}
