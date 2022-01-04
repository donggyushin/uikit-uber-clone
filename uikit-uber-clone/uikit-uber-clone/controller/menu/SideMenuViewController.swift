//
//  SideMenuViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2022/01/03.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = FontsColor.shared.primaryColor
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let driverLabel: UILabel = {
        let view = UILabel()
        view.text = "DRIVER"
        view.textColor = .systemGreen
        view.font = .systemFont(ofSize: 12)
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [usernameLabel, driverLabel])
        view.axis = .horizontal
        return view
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var riderSwitchButton: UISwitch = {
        let view = UISwitch()
        return view
    }()
    
    private let signOutButton: BlueButton = {
        let view = BlueButton(buttonTitleText: "Sign Out")
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [horizontalStackView, emailLabel, riderSwitchButton, UIView(), signOutButton])
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    
    
    let viewModel: SideMenuViewModel
    let mainViewModel: MainViewModel
    
    init(viewModel: SideMenuViewModel, mainViewModel: MainViewModel) {
        self.viewModel = viewModel
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configure()
        bind()
    }
    
    private func bind() {
        
        signOutButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel.logoutButtonTapped()
        }).disposed(by: viewModel.disposeBag)
        
        riderSwitchButton.rx.isOn.asDriver().drive(onNext: { [weak self] isOn in
            self?.viewModel.toggleButtonTapped()
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.$error.sink { [weak self] error in
            self?.view.makeToast(error?.localizedDescription)
        }.store(in: &viewModel.subscriber)
        
        viewModel.$user.compactMap({ $0 }).sink { [weak self] user in
            self?.usernameLabel.text = user.fullname
            self?.emailLabel.text = user.email
            self?.riderSwitchButton.isOn = user.userType == .DRIVER
            self?.driverLabel.isHidden = user.userType == .RIDER
        }.store(in: &viewModel.subscriber)
        
        viewModel.$isLogout.filter({ $0 }).sink { [weak self] _ in
            self?.dismiss(animated: true, completion: {
                self?.mainViewModel.logoutSuccess()
            })
        }.store(in: &viewModel.subscriber)
    }
    
    private func configure() {
        view.backgroundColor = .black
        view.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
    }
}
