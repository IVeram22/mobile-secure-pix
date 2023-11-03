//
//  PinCodeView.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 1.11.23.
//

import SnapKit

private enum Constants {
    static let numberOfCell: Int = 4
    static let width: CGFloat = 249
    static let cellSize: CGFloat = 51
    
    static let titleFont: UIFont = UIFont.systemFont(ofSize: 27)
    static let titleHeight: CFloat = 43
    static let errorMessageHeight: CFloat = 43
    
    static let inputFieldContainerOfSize: CFloat = 15
    
    static let errorMessageFont: UIFont = UIFont.systemFont(ofSize: 17)
    
    static let attempts: Int = 3
    
}

final class PinCodeView: UIView {
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Constants.titleFont
        label.textColor = .black
        return label
    }()
    
    private let inputFieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let errorMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Constants.errorMessageFont
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private var cells: [UITextField] = []
    private var attempts: Int = Constants.attempts
    private weak var viewControllerDelegate: ViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFielsChanged(_ textField: UITextField) {
        viewControllerDelegate?.changeText(textField)
    }
    
    // MARK: - Public
    func setViewControllerDelegate(with delegate: ViewControllerDelegate) {
        viewControllerDelegate = delegate
        addTextFieldsTargets()
    }
    
    func setFocusForFirstCell() {
        cells[0].becomeFirstResponder()
    }
    
    func getCells() -> [UITextField] {
        cells
    }
    
    func getPinCode() -> String {
        cells.map { $0.text ?? "" }.joined(separator: "")
    }
    
    func showErrorMessage() {
        errorMessage.isHidden = false
    }
    
    func hideErrorMessage() {
        errorMessage.isHidden = true
    }
    
    func reduceAttempts() {
        attempts -= 1
        errorMessage.text = setTextForErrorMessage()
        animatedInputFieldContainer()
        if attempts == 0 {
            viewControllerDelegate?.lockScreen()
        }
    }
    
    func clearCells() {
        cells.forEach { textField in
            textField.text = ""
        }
    }
    
    // MARK: - Private
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addTitle()
        addCells()
        addErrorMessage()
    }
    
    private func addTitle() {
        title.text = "Enter your PIN"
        addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.top.right.equalToSuperview()
            make.height.equalTo(Constants.titleHeight)
        }
    }
    
    private func addCells() {
        addSubview(inputFieldContainer)
        
        inputFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Constants.inputFieldContainerOfSize)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.width)
            make.height.equalTo(Constants.cellSize)
        }
        
        for i in 0...Constants.numberOfCell - 1 {
            createCell(step: i)
        }
        
    }
    
    private func createCell(step: Int) {
        let cell = UITextField(frame: CGRect(
            x: 0,
            y: 0,
            width: Constants.cellSize,
            height: Constants.cellSize))
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.layer.cornerRadius = Constants.cellSize / 2
        
        cell.keyboardType = .numberPad
        cell.font = UIFont.systemFont(ofSize: Constants.cellSize / 2)
        cell.textAlignment = .center
        cell.textColor = .red
        cell.isSecureTextEntry = true
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.systemRed.cgColor
        
        inputFieldContainer.addSubview(cell)
        
        cell.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(inputFieldContainer.snp.left)
                .offset(Constants.cellSize * CGFloat(step) + CGFloat(step) * CGFloat(Constants.inputFieldContainerOfSize))
            make.width.height.equalTo(Constants.cellSize)
        }
        
        cells.append(cell)
    }
    
    private func addTextFieldsTargets() {
        cells.forEach { textField in
            textField.addTarget(self, action: #selector(textFielsChanged), for: .editingChanged)
        }
    }
    
    private func addErrorMessage() {
        errorMessage.text = setTextForErrorMessage()
        addSubview(errorMessage)
        errorMessage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputFieldContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.errorMessageHeight)
        }
        errorMessage.isHidden = true
    }
    
    private func setTextForErrorMessage() -> String {
        "Invalid PIN\n Attempts before blocking: \(attempts)"
    }
    
    private func animatedInputFieldContainer() {
        inputFieldContainer.shakeAnimation(repeatCount: 2)
    }
    
}
