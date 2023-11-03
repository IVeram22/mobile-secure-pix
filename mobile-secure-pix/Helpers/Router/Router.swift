//
//  Router.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import SnapKit

private enum Constants {
    static let duration: CFTimeInterval = 0.3
    
}

final class Router {
    private let currentViewController: UIViewController!
    
    init(currentViewController: UIViewController!) {
        self.currentViewController = currentViewController
    }
    
    // MARK: - Private
    private func open(to nextViewController: UIViewController, type: CATransitionType, subtype: CATransitionSubtype) {
        nextViewController.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = Constants.duration
        transition.type = type
        transition.subtype = subtype
        currentViewController.view.window?.layer.add(transition, forKey: kCATransition)
        
        currentViewController.present(nextViewController, animated: false)
    }
}

// MARK: - Extensions
extension Router: PinCodeRouter {
    func giveAccess() {
        open(to: HomeViewController(), type: .moveIn, subtype: .fromLeft)
    }
    
    func lockScreen() {
        // TODO: Add Lock Screen
    }
    
}
