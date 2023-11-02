//
//  PinCodeView.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 1.11.23.
//

import Foundation
import SnapKit

private enum Constants {
    static let numberOfCell: Int = 4
    static let cellSize: CGFloat = 51
}

final class PinCodeView: UIView {
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 27)
        return label
    }()
    
    private let inputFieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cells: [UITextField] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func setDelegate() {
        
    }
    
    // MARK: - Private
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addTitle()
        addCells()
    }
    
    private func addTitle() {
        title.text = "Enter your PIN"
        addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.top.right.equalToSuperview()
            make.height.equalTo(43)
        }
    }
    
    private func addCells() {
        addSubview(inputFieldContainer)
        inputFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(249)
            make.height.equalTo(51)
        }
        
        
        for i in 0...Constants.numberOfCell - 1 {
            createCell(step: i)
        }
        
                            
                
    }
    
    private func createCell(step: Int) {
        let cell = UITextField(frame: CGRect(x: 0, y: 0, width: Constants.cellSize, height: Constants.cellSize))
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.layer.cornerRadius = Constants.cellSize / 2
        cell.backgroundColor = .red
        
        cell.keyboardType = .numberPad
        cell.font = UIFont.systemFont(ofSize: Constants.cellSize / 2)
        cell.textAlignment = .center
        cell.isSecureTextEntry = true
        
        inputFieldContainer.addSubview(cell)
        
        cell.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(inputFieldContainer.snp.left).offset(Constants.cellSize * CGFloat(step) + CGFloat(step) * 15)
            make.width.height.equalTo(Constants.cellSize)
        }
        
        cells.append(cell)
    }
    
}
