//
//  LockInputPresenter.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import Foundation

protocol LockInputPresenter: AnyObject {
    func updateTime(with time: String)
    func backToPinScreen()
}
