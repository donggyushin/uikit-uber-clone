//
//  SplashViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class SplashViewController: BaseViewController {
    
    private let splashViewModel: SplashViewModel
    
    private let logoLabel: LogoLabel = {
        let view = LogoLabel()
        view.text = "UBER"
        return view
    }()
    
    init(splashViewModel: SplashViewModel) {
        self.splashViewModel = splashViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureUI()
        bind()
    }
    
    private func bind() {
        
        splashViewModel.$navigationType.sink { [weak self] navigationType in
            guard let navigationType = navigationType else { return }
            switch navigationType {
            case .auth:
                self?.navigationController?.setViewControllers([DIViewController.resolve().loginViewControllerFactory()], animated: true)
            case .home:
                self?.navigationController?.setViewControllers([DIViewController.resolve().mainViewControllerFactory()], animated: true)
            }
        }.store(in: &subscriber)
    }
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = BackgroundColors.shared.primaryColor
        view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
}
