//
//  MechanicCellAnimator.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//
//

import UIKit

class MechanicCellAnimator {
    static func applyAppearAnimation(to cell: UITableViewCell, containerView: UIView, withDelay delay: Double = 0) {
        // Initial state
        containerView.transform = CGAffineTransform(translationX: 0, y: 50)
        containerView.alpha = 0
        
        // Spring animation
        UIView.animate(
            withDuration: 0.6,
            delay: delay,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                containerView.transform = .identity
                containerView.alpha = 1
            }
        )
    }
    
    static func applyBookButtonAnimation(to button: UIButton) {
        // Initial state
        button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        button.alpha = 0
        
        // Bounce animation
        UIView.animate(
            withDuration: 0.5,
            delay: 0.2,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                button.transform = .identity
                button.alpha = 1
            }
        )
    }
    
    static func applyHighlightAnimation(to containerView: UIView, isHighlighted: Bool) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                containerView.transform = isHighlighted ? 
                    CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
                containerView.layer.shadowOpacity = isHighlighted ? 0.2 : 0.1
            }
        )
    }
    
    static func applyTapAnimation(to button: UIButton, completion: @escaping () -> Void) {
        // Quick button feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        // Scale down animation
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        ) { _ in
            // Scale up animation
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    button.transform = .identity
                }
            ) { _ in
                completion()
            }
        }
    }
} 
