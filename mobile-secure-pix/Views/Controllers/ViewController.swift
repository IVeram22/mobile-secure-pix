//
//  ViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 1.11.23.
//

import UIKit

class ViewController: UIViewController {
    private var pinCodeView: PinCodeView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .blue
        setupInterface()
        setupPinCodeTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pinCodeView.cells[0].becomeFirstResponder()
    }

    // MARK: - Private
    private func setupInterface() {
        pinCodeView = PinCodeView(frame: CGRect(x: 0, y: 0, width: 301, height: 151))
        view.addSubview(pinCodeView)
        
        pinCodeView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(301)
            make.height.equalTo(151)
        }
        
    }
    
    private func setupPinCodeTextField() {
        pinCodeView.cells[0].addTarget(self, action: #selector(changeText), for: .editingChanged)
        pinCodeView.cells[1].addTarget(self, action: #selector(changeText), for: .editingChanged)
        pinCodeView.cells[2].addTarget(self, action: #selector(changeText), for: .editingChanged)
        pinCodeView.cells[3].addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    @objc func changeText(_ textField: UITextField) {
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField {
            case pinCodeView.cells[0]:
                pinCodeView.cells[1].becomeFirstResponder()
                break
            case pinCodeView.cells[1]:
                pinCodeView.cells[2].becomeFirstResponder()
                break
            case pinCodeView.cells[2]:
                pinCodeView.cells[3].becomeFirstResponder()
                break
            case pinCodeView.cells[3]:
                pinCodeView.cells[3].resignFirstResponder()
                break
            default:
                break
            }
        }
    }
    
    
}

protocol ViewControllerDelegate: AnyObject {
    func changeText(_ textField: UITextField)
}
