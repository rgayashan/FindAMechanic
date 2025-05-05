//
//  CustomTransitions.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.5
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        if isPresenting {
            // Add destination view to container
            containerView.addSubview(toVC.view)
            
            // Starting position - offscreen right
            toVC.view.frame = finalFrame.offsetBy(dx: finalFrame.width, dy: 0)
            
            // Subtle scale effect for the fromVC
            fromVC.view.layer.zPosition = -1
            
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
                
                // Move new view in from right
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                    toVC.view.frame = finalFrame
                }
                
                // Scale and fade the background slightly
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                    fromVC.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    fromVC.view.alpha = 0.7
                }
                
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                fromVC.view.transform = .identity
                fromVC.view.alpha = 1.0
            })
            
        } else {
            // Pop animation - bring previous view controller back
            
            // Make sure the fromVC is on top initially
            containerView.addSubview(fromVC.view)
            containerView.addSubview(toVC.view)
            
            // Prepare toVC state
            toVC.view.frame = finalFrame.offsetBy(dx: -finalFrame.width * 0.3, dy: 0)
            toVC.view.alpha = 0.7
            toVC.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
                
                // Move current view out to the right
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                    fromVC.view.frame = finalFrame.offsetBy(dx: finalFrame.width, dy: 0)
                }
                
                // Bring previous view back to normal
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.8) {
                    toVC.view.transform = .identity
                    toVC.view.alpha = 1.0
                    toVC.view.frame = finalFrame
                }
                
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
