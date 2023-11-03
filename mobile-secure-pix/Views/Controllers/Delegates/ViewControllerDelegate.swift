//
//  ViewControllerDelegate.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import SnapKit

protocol ViewControllerDelegate: AnyObject {
    func changeText(_ textField: UITextField)
    func lockScreen()
}
