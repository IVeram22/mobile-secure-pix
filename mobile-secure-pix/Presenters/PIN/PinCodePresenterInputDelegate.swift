//
//  PinCodePresenterInputDelegate.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import Foundation

protocol PinCodePresenterInputDelegate: AnyObject {
    func setupPinCode(with pin: String)
}
