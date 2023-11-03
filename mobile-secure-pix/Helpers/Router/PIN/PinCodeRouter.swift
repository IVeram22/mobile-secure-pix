//
//  PinCodeRouter.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import Foundation

protocol PinCodeRouter: AnyObject {
    func giveAccess()
    func lockScreen()
}
