//
//  CompletedView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/30.
//

import UIKit

class CompletedView: UIView {
    private let height: CGFloat = 150
    private let button: BlueButton = {
        let view = BlueButton(buttonTitleText: "ARRIVED!")
        return view
    }()
    
    let viewModel: CompletedViewModel
    
    init(viewModel: CompletedViewModel) {
        self.viewModel = viewModel
        super.init(frame: .init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.height))
        configureUI()
        present()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        button.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.viewModel.arrivedButtonTapped()
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.$error.sink { [weak self] error in
            self?.makeToast(error?.localizedDescription)
        }.store(in: &viewModel.subscriber)
        
        viewModel.$isLoading.sink { [weak self] loading in
            self?.button.isEnabled = !loading
        }.store(in: &viewModel.subscriber)
        
        viewModel.$success.filter({ $0 }).sink { [weak self] _ in
            self?.dismiss()
        }.store(in: &viewModel.subscriber)
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.transform = .init(translationX: 0, y: 0)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    private func configureUI() {
        backgroundColor = BackgroundColors.shared.primaryColor
        layer.cornerRadius = 8
        addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
        }
    }
    
    private func present() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.transform = .init(translationX: 0, y: -self.height)
        }
    }
}
