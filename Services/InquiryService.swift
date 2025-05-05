//
//  InquiryService.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-04-28.
//

import Foundation

class InquiryService {
    
    static let shared = InquiryService()
    
    private init() {}
    
    func submitInquiry(inquiry: InquiryForm, completion: @escaping (Bool, Error?) -> Void) {
        // Here you would implement the actual API call to submit the inquiry
        // For now we'll simulate a network request with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Simulate successful submission
            completion(true, nil)
        }
    }
}
