//
//  LockViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import SnapKit

final class LockViewController: UIViewController {
    // MARK: Interface
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 27)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 27)
        label.textColor = .systemRed
        label.numberOfLines = 0
        return label
    }()
    
    private var lockPresenter: LockOutputPresenter!
    private var router: BackToPinCodeRouter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupPresenters()
        setupRouter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lockPresenter.startTimer()
    }
    
    // MARK: - Private
    private func setupInterface() {
        view.setupMainView()
        setupTitleLabel()
        setupTimeLabel()
    }

    private func setupTitleLabel() {
        titleLabel.text = "Application is blocked :("
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-47)
            make.left.right.equalToSuperview()
            make.height.equalTo(43)
        }
    }

    private func setupTimeLabel() {
        timeLabel.text = ""
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(43)
        }
    }
    
    private func setupPresenters() {
        lockPresenter = LockPresenter(lockInputPresenter: self)
    }
    
    private func setupRouter() {
        router = Router(currentViewController: self)
    }

}

extension LockViewController: LockInputPresenter {
    func updateTime(with time: String) {
        timeLabel.text = time
    }
    
    func backToPinScreen() {
        router.backToPinScreen()
    }
    
}
