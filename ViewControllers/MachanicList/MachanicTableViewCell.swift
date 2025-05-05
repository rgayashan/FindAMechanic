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
    private let containerView = UIView()
    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let addressLine1Label = UILabel()
    private let addressLine2Label = UILabel()
    private let phoneLabel = UILabel()
    private let bookButton = UIButton(type: .system)
    
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
        contentView.backgroundColor = .systemGroupedBackground
        
        // Container View
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.addSubview(containerView)
        
        // Logo Image View
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.backgroundColor = .systemGray6
        logoImageView.layer.cornerRadius = 6
        logoImageView.clipsToBounds = true
        containerView.addSubview(logoImageView)
        
        // Name Label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = .black
        containerView.addSubview(nameLabel)
        
        // Address Line 1
        addressLine1Label.translatesAutoresizingMaskIntoConstraints = false
        addressLine1Label.font = UIFont.systemFont(ofSize: 14)
        addressLine1Label.textColor = .darkGray
        containerView.addSubview(addressLine1Label)
        
        // Address Line 2
        addressLine2Label.translatesAutoresizingMaskIntoConstraints = false
        addressLine2Label.font = UIFont.systemFont(ofSize: 14)
        addressLine2Label.textColor = .darkGray
        containerView.addSubview(addressLine2Label)
        
        // Phone Label
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.textColor = .darkGray
        containerView.addSubview(phoneLabel)
        
        // Book Button
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        bookButton.setTitle("Book Online", for: .normal)
        bookButton.setTitleColor(.white, for: .normal)
        bookButton.backgroundColor = .systemBlue
        bookButton.layer.cornerRadius = 8
        bookButton.addTarget(self, action: #selector(bookButtonTapped), for: .touchUpInside)
        containerView.addSubview(bookButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Logo constraints
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            logoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Address Line 1 constraints
            addressLine1Label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addressLine1Label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLine1Label.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Address Line 2 constraints
            addressLine2Label.topAnchor.constraint(equalTo: addressLine1Label.bottomAnchor, constant: 4),
            addressLine2Label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLine2Label.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Phone constraints
            phoneLabel.topAnchor.constraint(equalTo: addressLine2Label.bottomAnchor, constant: 8),
            phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Book button constraints
            bookButton.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 16),
            bookButton.trailingAnchor.constraint(equalTo: phoneLabel.trailingAnchor),
            bookButton.heightAnchor.constraint(equalToConstant: 44),
            bookButton.widthAnchor.constraint(equalToConstant: 150),
            bookButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration Methods
    func configure(with mechanic: Mechanic) {
        self.mechanic = mechanic
        nameLabel.text = mechanic.name
        addressLine1Label.text = mechanic.addressLine1
        addressLine2Label.text = mechanic.addressLine2
        phoneLabel.text = "Phone: \(mechanic.phone)"
        
        if let logoUrl = mechanic.logoUrl {
            loadImage(from: logoUrl)
        } else {
            logoImageView.image = UIImage(named: "placeholder")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.addButtonPulseAnimation()
        }
    }
    
    private func loadImage(from urlString: String) {
        // In a real app, use SDWebImage or Kingfisher to load images asynchronously
        DispatchQueue.global().async {
            if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [weak self] in
                    self?.logoImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    // MARK: - Animation Methods
    func animateOnAppear(withDelay delay: Double = 0) {
        // Initial state
        alpha = 0
        transform = CGAffineTransform(translationX: -20, y: 0)
        containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        // Spring animation
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations: {
            self.alpha = 1
            self.transform = .identity
            self.containerView.transform = .identity
        })
    }
    
    private func addButtonPulseAnimation() {
        // First fade in with a slight bounce
        bookButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        bookButton.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6,
                      initialSpringVelocity: 0.5, options: [], animations: {
            self.bookButton.transform = .identity
            self.bookButton.alpha = 1
        }) { _ in
            // Then do a subtle pulse animation
            let pulseAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            pulseAnimation.values = [1.0, 1.06, 1.0]
            pulseAnimation.keyTimes = [0, 0.5, 1]
            pulseAnimation.duration = 1.2
            pulseAnimation.timingFunctions = [
                CAMediaTimingFunction(name: .easeInEaseOut),
                CAMediaTimingFunction(name: .easeInEaseOut)
            ]
            pulseAnimation.repeatCount = 2
            self.bookButton.layer.add(pulseAnimation, forKey: "pulse")
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.containerView.transform = highlighted ?
                CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
                self.containerView.backgroundColor = highlighted ?
                UIColor.systemGray6 : .white
            }
        }
    }
    
    // MARK: - Actions
    @objc private func bookButtonTapped() {
        // Quick button feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        // Animated button response
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [], animations: {
            // First shrink
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                self.bookButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            
            // Then expand slightly beyond normal
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                self.bookButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            
            // Then back to normal
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
                self.bookButton.transform = .identity
            }
        }) { _ in
            guard let mechanic = self.mechanic else { return }
            self.delegate?.didTapBookButton(for: mechanic)
        }
    }
}
