//
//  LoginViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit
import SnapKit
import RxCocoa

class LoginViewController: BaseViewController {
    
    private let logoLabel: LogoLabel = {
        let view = LogoLabel()
        view.text = "UBER"
        return view
    }()
    
    private let emailTextFieldView: UserInputTextFieldView = {
        let view = UserInputTextFieldView(iconImageString: "envelope", placeholderString: "Email")
        return view
    }()
    
    private let passwordTextFieldView: UserInputTextFieldView = {
        let view = UserInputTextFieldView(iconImageString: "lock", placeholderString: "Password")
        view.tf.isSecureTextEntry = true
        return view
    }()
    
    private let loginButton: BlueButton = {
        let view = BlueButton(buttonTitleText: "Log In")
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView, loginButton])
        view.spacing = 30
        view.axis = .vertical
        return view
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let view = UIButton(type: .system)
        let attributedTitleText: NSMutableAttributedString = .init(string: "Don't have an account? ", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),                                  .foregroundColor: UIColor.lightGray
        ])
        
        attributedTitleText.append(.init(string: "Sign Up", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
            .foregroundColor: FontsColor.shared.blue
        ]))
        
        view.setAttributedTitle(attributedTitleText, for: .normal)
        return view
    }()
    
    private let loginViewModel: LoginViewModel
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func bind() {
        
        dontHaveAccountButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.navigationController?.pushViewController(DIViewController.resolve().signUpViewControllerFactory(), animated: true)
        }).disposed(by: disposeBag)
        
        loginButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.loginViewModel.login(email: self?.emailTextFieldView.tf.text ?? "", password: self?.passwordTextFieldView.tf.text ?? "")
        }).disposed(by: disposeBag)
        
        loginViewModel.isLoading.asDriver(onErrorJustReturn: false).drive(onNext: { [weak self] loading in
            loading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            self?.loginButton.isEnabled = !loading
        }).disposed(by: disposeBag)
        
        loginViewModel.error.asDriver(onErrorJustReturn: nil).filter({ $0 != nil }).drive(onNext: { [weak self] error in
            self?.view.makeToast(error?.localizedDescription)
        }).disposed(by: disposeBag)
        
        loginViewModel.user.asDriver(onErrorJustReturn: nil).filter({ $0 != nil }).drive(onNext: { [weak self] _ in
            self?.navigationController?.setViewControllers([DIViewController.resolve().mainViewControllerFactory()], animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true 
        view.backgroundColor = BackgroundColors.shared.primaryColor
        view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(40)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
