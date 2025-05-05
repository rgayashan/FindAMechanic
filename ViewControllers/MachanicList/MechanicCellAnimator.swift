import UIKit

class MechanicCellAnimator {
    static func applyAppearAnimation(to cell: UITableViewCell, containerView: UIView, withDelay delay: Double = 0) {
        // Initial state
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: -20, y: 0)
        containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        // Spring animation
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations: {
            cell.alpha = 1
            cell.transform = .identity
            containerView.transform = .identity
        })
    }
    
    static func applyButtonAnimation(to button: UIButton) {
        // First fade in with a slight bounce
        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        button.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6,
                      initialSpringVelocity: 0.5, options: [], animations: {
            button.transform = .identity
            button.alpha = 1
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
            button.layer.add(pulseAnimation, forKey: "pulse")
        }
    }
    
    static func applyHighlightAnimation(to containerView: UIView, isHighlighted: Bool) {
        UIView.animate(withDuration: 0.1) {
            containerView.transform = isHighlighted ?
            CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            containerView.backgroundColor = isHighlighted ?
            UIColor.systemGray6 : .white
        }
    }
    
    static func applyTapAnimation(to button: UIButton, completion: @escaping () -> Void) {
        // Quick button feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        // Animated button response
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [], animations: {
            // First shrink
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            
            // Then expand slightly beyond normal
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            
            // Then back to normal
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
                button.transform = .identity
            }
        }) { _ in
            completion()
        }
    }
} 