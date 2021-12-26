//
//  LocationInputHeaderView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit
import RxSwift

class LocationInputHeaderView: UIView {
    
    private let locationInputActivationView: LocationInputActivationView
    private let backButton = BackButton()
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    private let startingTextFieldView: LocationInputTextField = {
        let view = LocationInputTextField(placeHolderText: "Current location")
        view.isEnabled = false
        view.alpha = 0.8
        return view
    }()
    
    private let startingDotView: DotView = {
        let view = DotView()
        view.setColor(.darkGray)
        return view
    }()
    
    private let destinationTextFieldView: UITextField = {
        let view = LocationInputTextField(placeHolderText: "Enter destination")
        return view
    }()
    
    private let destinationDotView: DotView = {
        let view = DotView()
        view.setColor(UIColor(white: 1, alpha: 0.8))
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        view.backgroundColor = .darkGray
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [startingTextFieldView, destinationTextFieldView])
        view.axis = .vertical
        view.spacing = 15
        return view
    }()
    
    init(locationInputActivationView: LocationInputActivationView) {
        self.locationInputActivationView = locationInputActivationView
        super.init(frame: CGRect.zero)
        
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
        UserViewModel.shared.user.asDriver(onErrorJustReturn: nil).drive(onNext: { [weak self] user in
            self?.titleLabel.text = user?.fullname
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.hide()
            self?.locationInputActivationView.show()
        }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        backgroundColor = BackgroundColors.shared.primaryColor
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.safeAreaLayoutGuide)
        }
        
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.left.equalTo(self).offset(12)
        }
        
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalTo(backButton.snp.right).offset(10)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-30)
        }
        
        addSubview(startingDotView)
        startingDotView.snp.makeConstraints { make in
            make.centerY.equalTo(startingTextFieldView)
            make.right.equalTo(startingTextFieldView.snp.left).offset(-12)
        }
        
        addSubview(destinationDotView)
        destinationDotView.snp.makeConstraints { make in
            make.centerY.equalTo(destinationTextFieldView)
            make.centerX.equalTo(startingDotView)
        }
        
        addSubview(line)
        line.snp.makeConstraints { make in
            make.centerX.equalTo(destinationDotView)
            make.top.equalTo(startingDotView.snp.bottom).offset(4)
            make.bottom.equalTo(destinationDotView.snp.top).offset(-4)
        }
        
        alpha = 0 
    }
    
}
