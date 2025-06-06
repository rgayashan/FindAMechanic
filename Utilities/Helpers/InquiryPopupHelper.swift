//
//  InquiryPopupHelper.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import UIKit

class InquiryPopupHelper {
    
    static func showInquiryPopup(from viewController: UIViewController, mechanicName: String, delegate: InquiryPopupDelegate?, tenantId: Int) {
        let popupVC = InquiryPopupViewController()
        popupVC.mechanicName = mechanicName
        popupVC.tenantId = tenantId
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = delegate
        
        viewController.present(popupVC, animated: true)
    }
}
