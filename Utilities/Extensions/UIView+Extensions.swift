//
//  UIView+Extensions.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import UIKit

extension UIView {
    func addShadow(opacity: Float = 0.2, radius: CGFloat = 3, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    func roundCorners(radius: CGFloat = 8) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func addBorder(color: UIColor = .systemGray4, width: CGFloat = 0.5) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
