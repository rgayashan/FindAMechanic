//
//  MechanicListNavigationDelegate.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-26.
//

import UIKit

class MechanicListNavigationDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // Only use custom animation for transitions between list and detail
        guard (fromVC is MechanicListViewController && toVC is MechanicDetailViewController) ||
              (fromVC is MechanicDetailViewController && toVC is MechanicListViewController) else {
            return nil
        }
        
        // Use custom transition based on operation
        switch operation {
        case .push:
            return SlideInTransition(isPresenting: true)
        case .pop:
            return SlideInTransition(isPresenting: false)
        default:
            return nil
        }
    }
}
