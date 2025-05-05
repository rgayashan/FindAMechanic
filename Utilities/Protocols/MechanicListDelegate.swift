//
//  MechanicListDelegate.swift
//  Find a Mechanic
//
//  Created by Rajitha Gayashan on 2025-04-25.
//

import Foundation

protocol MechanicTableViewCellDelegate: AnyObject {
    func didTapBookButton(for mechanic: Mechanic)
}
