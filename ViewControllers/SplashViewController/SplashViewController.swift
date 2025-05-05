//
//  SplashViewController.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    private lazy var appLogoView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "spalsh-logo"))
        view.contentMode = .scaleAspectFit
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var taglineLabel: UILabel = {
        let label = UILabel()
        label.text = "Find Reliable Mechanics Near You"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var poweredByLabel: UILabel = {
        let label = UILabel()
        label.text = "Powered By"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var vemasLogoView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "vemas"))
        view.contentMode = .scaleAspectFit
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var indicatorContainer: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Setup Methods
    private func setupBackground() {
        // Create a subtle gradient background
        gradientLayer.colors = [
            UIColor(named: "splash-bg")?.withAlphaComponent(0.9).cgColor ?? UIColor.white.cgColor,
            UIColor(named: "splash-bg")?.withAlphaComponent(1.0).cgColor ?? UIColor.lightGray.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        [appLogoView, taglineLabel, indicatorContainer, poweredByLabel, vemasLogoView].forEach(view.addSubview)
        
        // Setup constraints with better spacing
        NSLayoutConstraint.activate([
            appLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            appLogoView.widthAnchor.constraint(equalToConstant: 180),
            appLogoView.heightAnchor.constraint(equalToConstant: 180),
            
            taglineLabel.topAnchor.constraint(equalTo: appLogoView.bottomAnchor, constant: 16),
            taglineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taglineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            indicatorContainer.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 30),
            indicatorContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorContainer.widthAnchor.constraint(equalToConstant: 40),
            indicatorContainer.heightAnchor.constraint(equalToConstant: 40),
            
            poweredByLabel.bottomAnchor.constraint(equalTo: vemasLogoView.topAnchor, constant: -8),
            poweredByLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            vemasLogoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            vemasLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vemasLogoView.heightAnchor.constraint(equalToConstant: 80),
            vemasLogoView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        SplashAnimator.executeAnimationSequence(
            appLogo: appLogoView,
            tagline: taglineLabel,
            indicatorContainer: indicatorContainer,
            poweredBy: poweredByLabel,
            vemasLogo: vemasLogoView
        ) { [weak self] in
            self?.transitionToMainScreen()
        }
    }
    
    private func transitionToMainScreen() {
        let tabBarController = TabBarConfigurator.configure()
        
        LoadingIndicator.hide(animated: true) { [weak self] in
            UIView.animate(withDuration: 0.2) {
                self?.indicatorContainer.alpha = 0
            } completion: { _ in
                self?.present(tabBarController, animated: true)
            }
        }
    }
}
