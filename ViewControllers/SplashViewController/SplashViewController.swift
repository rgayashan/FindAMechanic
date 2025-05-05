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
        // App logo
        let appLogoView = UIImageView(image: UIImage(named: "spalsh-logo"))
        appLogoView.contentMode = .scaleAspectFit
        appLogoView.translatesAutoresizingMaskIntoConstraints = false
        appLogoView.alpha = 0
        view.addSubview(appLogoView)
        
        // App tagline
        let taglineLabel = UILabel()
        taglineLabel.text = "Find Reliable Mechanics Near You"
        taglineLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        taglineLabel.textColor = .darkGray
        taglineLabel.textAlignment = .center
        taglineLabel.translatesAutoresizingMaskIntoConstraints = false
        taglineLabel.alpha = 0
        view.addSubview(taglineLabel)
        
        // Powered By label
        let poweredByLabel = UILabel()
        poweredByLabel.text = "Powered By"
        poweredByLabel.font = UIFont.systemFont(ofSize: 14)
        poweredByLabel.textColor = .darkGray
        poweredByLabel.translatesAutoresizingMaskIntoConstraints = false
        poweredByLabel.alpha = 0
        view.addSubview(poweredByLabel)
        
        // VEMAS logo
        let vemasLogoView = UIImageView(image: UIImage(named: "vemas"))
        vemasLogoView.contentMode = .scaleAspectFit
        vemasLogoView.translatesAutoresizingMaskIntoConstraints = false
        vemasLogoView.alpha = 0
        view.addSubview(vemasLogoView)
        
        // Create a container for the activity indicator
        let indicatorContainer = UIView()
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        indicatorContainer.alpha = 0
        view.addSubview(indicatorContainer)
        
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
        
        // Start the animation sequence
        executeAnimationSequence(
            appLogo: appLogoView,
            tagline: taglineLabel,
            indicatorContainer: indicatorContainer,
            poweredBy: poweredByLabel,
            vemasLogo: vemasLogoView
        )
    }
    
    // MARK: - Animation Methods
    private func executeAnimationSequence(appLogo: UIImageView, tagline: UILabel, indicatorContainer: UIView, poweredBy: UILabel, vemasLogo: UIImageView) {
        
        // Prepare initial transforms
        appLogo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        vemasLogo.transform = CGAffineTransform(translationX: 0, y: 30)
        tagline.transform = CGAffineTransform(translationX: -20, y: 0)
        
        // 1. Logo animation with bounce effect
        UIView.animate(withDuration: 0.9, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            appLogo.alpha = 1.0
            appLogo.transform = CGAffineTransform.identity
        }) { _ in
            // Add subtle pulse animation to the logo
            self.addPulseAnimation(to: appLogo, duration: 2.0)
            
            // 2. Animate in the tagline with slide effect
            UIView.animate(withDuration: 0.7, delay: 0.1, options: .curveEaseOut, animations: {
                tagline.alpha = 1.0
                tagline.transform = CGAffineTransform.identity
            }) { _ in
                // 3. Show and start the activity indicator
                UIView.animate(withDuration: 0.5, animations: {
                    indicatorContainer.alpha = 1.0
                }) { _ in
                    // Show the loading indicator using our new class
                    LoadingIndicator.show(in: indicatorContainer, style: .medium, backgroundColor: .clear)
                    
                    // 4. After a short delay, animate in the "Powered By" text
                    UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseIn, animations: {
                        poweredBy.alpha = 1.0
                    }) { _ in
                        // 5. Finally, animate in the VEMAS logo with a nice spring effect
                        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                            vemasLogo.alpha = 1.0
                            vemasLogo.transform = CGAffineTransform.identity
                        }) { _ in
                            // Add subtle rotating shine effect to VEMAS logo
                            self.addShineEffect(to: vemasLogo)
                            
                            // Wait and then transition to main screen
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                self.transitionToMainScreen(indicatorContainer: indicatorContainer)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func addPulseAnimation(to view: UIView, duration: Double) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = duration
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.05
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 1
        view.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    private func addShineEffect(to view: UIView) {
        // Create a shine layer
        let shineLayer = CALayer()
        shineLayer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        shineLayer.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width/3, height: view.frame.height)
        shineLayer.transform = CATransform3DMakeRotation(CGFloat.pi/4, 0, 0, 1)
        view.layer.mask = nil
        view.layer.addSublayer(shineLayer)
        
        // Animate the shine layer
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = -view.frame.width
        animation.toValue = view.frame.width * 2
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        shineLayer.add(animation, forKey: "shineEffect")
        
        // Remove the shine layer after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            shineLayer.removeFromSuperlayer()
        }
    }
    
    private func transitionToMainScreen(indicatorContainer: UIView) {
        let tabBarController = UITabBarController()
        
        // Setup tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "splash-bg")?.withAlphaComponent(0.95)
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Configure Mechanic List tab
        let mechanicListVC = MechanicListViewController()
        let mechanicListNav = UINavigationController(rootViewController: mechanicListVC)
        mechanicListNav.tabBarItem = UITabBarItem(
            title: "Mechanics",
            image: UIImage(systemName: "wrench"),
            selectedImage: UIImage(systemName: "wrench.fill")
        )
        
        tabBarController.viewControllers = [mechanicListNav]
        
        // Create a smooth transition to main app
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        
        // Hide loading indicator
        LoadingIndicator.hide(animated: true) {
            UIView.animate(withDuration: 0.2, animations: {
                indicatorContainer.alpha = 0
            }) { _ in
                self.present(tabBarController, animated: true)
            }
        }
    }
}
