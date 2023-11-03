//
//  LockPresenter.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import Foundation

// TODO: need to make a timer and save status locked
final class LockPresenter {
    private weak var lockInputPresenter: LockInputPresenter!
    private var timer: Timer!
    private var currentTime: Int = 5
    private var counter: Int = 60
    
    // MARK: - Lifecycle
    init(lockInputPresenter: LockInputPresenter!) {
        self.lockInputPresenter = lockInputPresenter
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] _ in
            counter -= 1

            lockInputPresenter?.updateTime(with: formatNumbers(currentTime, counter))
            
            if counter == 0 {
                currentTime -= 1
                counter = 60
            }
            
            if currentTime == 0 {
                stopTimer()
            }
        }
    }
    
    // MARK: - Private
    private func formatNumbers(_ number1: Int, _ number2: Int) -> String {
        let formattedNumber1 = String(format: "%02d", number1)
        let formattedNumber2 = String(format: "%02d", number2)
        return "\(formattedNumber1)m \(formattedNumber2)s"
    }
    
}

// MARK: - Extensions
extension LockPresenter: LockOutputPresenter {
    func startTimer() {
        timer.fire()
    }
    
    func stopTimer() {
        timer.invalidate()
        timer = nil
        lockInputPresenter?.updateTime(with: "You are unblocked")
        lockInputPresenter?.backToPinScreen()
    }

}
