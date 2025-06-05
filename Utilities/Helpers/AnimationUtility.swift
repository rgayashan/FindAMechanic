//
//  AnimationUtility.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit

/// Utility class for common animations used across the app
class AnimationUtility {
    
    // MARK: - Fade Animations
    
    /// Fade in a view
    /// - Parameters:
    ///   - view: The view to fade in
    ///   - duration: Animation duration in seconds
    ///   - delay: Delay before animation starts
    ///   - completion: Completion handler
    static func fadeIn(_ view: UIView, duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        view.alpha = 0.0
        view.isHidden = false
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            view.alpha = 1.0
        }, completion: completion)
    }
    
    /// Fade out a view
    /// - Parameters:
    ///   - view: The view to fade out
    ///   - duration: Animation duration in seconds
    ///   - delay: Delay before animation starts
    ///   - completion: Completion handler
    static func fadeOut(_ view: UIView, duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            view.alpha = 0.0
        }, completion: { finished in
            view.isHidden = true
            completion?(finished)
        })
    }
    
    // MARK: - Scale Animations
    
    /// Scale a view up from 0
    /// - Parameters:
    ///   - view: The view to scale
    ///   - duration: Animation duration in seconds
    ///   - delay: Delay before animation starts
    ///   - completion: Completion handler
    static func scaleIn(_ view: UIView, duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        view.alpha = 0.0
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.isHidden = false
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            view.alpha = 1.0
            view.transform = CGAffineTransform.identity
        }, completion: completion)
    }
    
    /// Scale a view down to 0
    /// - Parameters:
    ///   - view: The view to scale
    ///   - duration: Animation duration in seconds
    ///   - delay: Delay before animation starts
    ///   - completion: Completion handler
    static func scaleOut(_ view: UIView, duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            view.alpha = 0.0
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { finished in
            view.isHidden = true
            view.transform = CGAffineTransform.identity
            completion?(finished)
        })
    }
    
    // MARK: - Slide Animations
    
    /// Slide in a view from the bottom
    /// - Parameters:
    ///   - view: The view to slide in
    ///   - duration: Animation duration in seconds
    ///   - delay: Delay before animation starts
    ///   - completion: Completion handler
    static func slideInFromBottom(_ view: UIView, duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        let originalFrame = view.frame
        view.frame.origin.y = UIScreen.main.bounds.height
        view.isHidden = false
        view.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            view.frame = originalFrame
        }, completion: completion)
    }
    
    /// Slide out a view to the bottom
    /// - Parameters:
    ///   - view: The view to slide out
    ///   - duration: Animation duration in seconds
    ///   - delay: Delay before animation starts
    ///   - completion: Completion handler
    static func slideOutToBottom(_ view: UIView, duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            view.frame.origin.y = UIScreen.main.bounds.height
        }, completion: { finished in
            view.isHidden = true
            completion?(finished)
        })
    }
    
    // MARK: - Shake Animation
    
    /// Shake a view to indicate an error
    /// - Parameters:
    ///   - view: The view to shake
    ///   - duration: Animation duration in seconds
    ///   - completion: Completion handler
    static func shake(_ view: UIView, duration: TimeInterval = 0.6, completion: ((Bool) -> Void)? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        view.layer.add(animation, forKey: "shake")
        
        // Call completion after animation finishes
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?(true)
        }
    }
    
    // MARK: - Pulse Animation
    
    /// Add a pulsing animation to a view
    /// - Parameters:
    ///   - view: The view to animate
    ///   - duration: Animation duration in seconds
    static func addPulseAnimation(to view: UIView, duration: TimeInterval = 1.5) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = duration
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        view.layer.add(pulse, forKey: "pulse")
    }
    
    /// Remove the pulsing animation from a view
    /// - Parameter view: The view to stop animating
    static func removePulseAnimation(from view: UIView) {
        view.layer.removeAnimation(forKey: "pulse")
    }
} 
