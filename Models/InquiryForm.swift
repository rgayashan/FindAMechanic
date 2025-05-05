//
//  InquiryForm.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import Foundation

struct InquiryForm {
    var vehicleRegistration: String = ""
    var name: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var date: Date?
    var message: String = ""
    
    var isValid: Bool {
        return !vehicleRegistration.isEmpty &&
               !name.isEmpty &&
               !email.isEmpty &&
               !phoneNumber.isEmpty &&
               date != nil
    }
}
