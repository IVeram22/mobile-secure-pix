//
//  PinCodePresenter.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import Foundation

final class PinCodePresenter {
    private weak var inputDelegate: PinCodePresenterInputDelegate!
    
    init(with inputDelegate: PinCodePresenterInputDelegate) {
        self.inputDelegate = inputDelegate
    }
    
    // MARK: - Private
    private func loadPinCode() {
        // TODO: PinManager
        inputDelegate.setupPinCode(with: "1234")
    }
    
}

// MARK: - Extensions
extension PinCodePresenter: PinCodePresenterOutputDelegate {
    func getPin() {
        loadPinCode()
    }

}
