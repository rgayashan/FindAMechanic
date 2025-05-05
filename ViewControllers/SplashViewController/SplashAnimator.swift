//
//  SplashAnimator.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-05-05.
//

import UIKit

class SplashAnimator {
    static func executeAnimationSequence(
        appLogo: UIImageView,
        tagline: UILabel,
        indicatorContainer: UIView,
        poweredBy: UILabel,
        vemasLogo: UIImageView,
        completion: @escaping () -> Void
    ) {
        // Prepare initial transforms
        appLogo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        vemasLogo.transform = CGAffineTransform(translationX: 0, y: 30)
        tagline.transform = CGAffineTransform(translationX: -20, y: 0)
        
        // 1. Logo animation
        UIView.animate(withDuration: 0.9, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseOut) {
            appLogo.alpha = 1.0
            appLogo.transform = .identity
        } completion: { _ in
            addPulseAnimation(to: appLogo)
            animateTagline(tagline, indicatorContainer, poweredBy, vemasLogo, completion: completion)
        }
    }
    
    private static func animateTagline(_ tagline: UILabel, _ indicatorContainer: UIView, _ poweredBy: UILabel, _ vemasLogo: UIImageView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.7, delay: 0.1, options: .curveEaseOut) {
            tagline.alpha = 1.0
            tagline.transform = .identity
        } completion: { _ in
            animateIndicator(indicatorContainer, poweredBy, vemasLogo, completion: completion)
        }
    }
    
    private static func animateIndicator(_ indicatorContainer: UIView, _ poweredBy: UILabel, _ vemasLogo: UIImageView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5) {
            indicatorContainer.alpha = 1.0
        } completion: { _ in
            LoadingIndicator.show(in: indicatorContainer, style: .medium, backgroundColor: .clear)
            animatePoweredBy(poweredBy, vemasLogo, completion: completion)
        }
    }
    
    private static func animatePoweredBy(_ poweredBy: UILabel, _ vemasLogo: UIImageView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseIn) {
            poweredBy.alpha = 1.0
        } completion: { _ in
            animateVemasLogo(vemasLogo, completion: completion)
        }
    }
    
    private static func animateVemasLogo(_ vemasLogo: UIImageView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut) {
            vemasLogo.alpha = 1.0
            vemasLogo.transform = .identity
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: completion)
        }
    }
    
    private static func addPulseAnimation(to view: UIView) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 2.0
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.05
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 1
        view.layer.add(pulseAnimation, forKey: "pulse")
    }
    
} 
