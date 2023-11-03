//
//  ViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 1.11.23.
//

import SnapKit

private enum Constants {
    enum PinCodeView {
        static let width: CGFloat = 381
        static let height: CGFloat = 171
    }
    
}

final class ViewController: UIViewController {
    private var pinCodeView: PinCodeView!
    private var router: PinCodeRouter!
    private var pinCodePresenter: PinCodePresenter!
    private var currentPinCode = ""
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupRouter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pinCodeView.setFocusForFirstCell()
    }

    // MARK: - Private
    private func setupInterface() {
        view.setupMainView()
        setupPinCodeView()
        setupPresenters()
    }
    
    private func setupPresenters() {
        pinCodePresenter = PinCodePresenter(with: self)
        pinCodePresenter.getPin()
    }
    
    private func setupPinCodeView() {
        pinCodeView = PinCodeView(frame: CGRect(
            x: 0,
            y: 0,
            width: Constants.PinCodeView.width,
            height: Constants.PinCodeView.height))
        view.addSubview(pinCodeView)
        
        pinCodeView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(Constants.PinCodeView.width)
            make.height.equalTo(Constants.PinCodeView.height)
        }
        
        pinCodeView.setViewControllerDelegate(with: self)
    }
    
    private func checkPinCode() {
        if pinCodeView.getPinCode().elementsEqual(currentPinCode) {
            pinCodeView.hideErrorMessage()
            router.giveAccess()
        } else {
            pinCodeView.showErrorMessage()
            pinCodeView.reduceAttempts()
            pinCodeView.clearCells()
            pinCodeView.setFocusForFirstCell()
        }
    }
    
    private func setupRouter() {
        router = Router(currentViewController: self)
    }
    
}

// MARK: - Extensions
extension ViewController: ViewControllerDelegate {
    @objc func changeText(_ textField: UITextField) {
        let cells = pinCodeView.getCells()
        guard cells.count == 4 else { return }
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField {
            case cells[0]:
                cells[1].becomeFirstResponder()
                break
            case cells[1]:
                cells[2].becomeFirstResponder()
                break
            case cells[2]:
                cells[3].becomeFirstResponder()
                break
            case cells[3]:
                cells[3].resignFirstResponder()
                checkPinCode()
                break
            default:
                break
            }
        }
    }
    
    func lockScreen() {
        router.lockScreen()
    }
    
}

extension ViewController: PinCodePresenterInputDelegate {
    func setupPinCode(with pin: String) {
        currentPinCode = pin
    }
    
}
