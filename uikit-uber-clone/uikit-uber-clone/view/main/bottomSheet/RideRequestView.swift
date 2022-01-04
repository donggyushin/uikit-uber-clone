//
//  RightRequestView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/27.
//

import UIKit
import RxSwift
import Combine

protocol RideRequestViewDelegate: AnyObject {
    func rideRequestViewDismiss()
    func rideRequestSuccess()
}

class RideRequestView: UIView {
    
    static let height: CGFloat = 280
    private let disposeBag = DisposeBag()
    weak var delegate: RideRequestViewDelegate?
    
    private let paddingFactory: () -> UIView = {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(10)
        }
        return view
    }
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "Test Title"
        view.textColor = FontsColor.shared.primaryColor
        view.textAlignment = .center
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "Test Description"
        view.textAlignment = .center
        view.textColor = .lightGray
        return view
    }()
    
    private let xmarkButton: UIButton = {
        let view = UIButton(type: .system)
        view.configuration = .tinted()
        view.configuration?.image = .init(systemName: "xmark")
        view.configuration?.baseBackgroundColor = .yellow
        view.configuration?.baseForegroundColor = .yellow
        view.configuration?.cornerStyle = .capsule
        return view
    }()
    
    private let confirmButton: UIButton = {
        let view = UIButton(type: .system)
        view.configuration = .tinted()
        view.setTitle("CONFIRM", for: .normal)
        view.configuration?.baseBackgroundColor = .systemPink
        view.configuration?.baseForegroundColor = .systemPink
        view.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(UIScreen.main.bounds.width - 64)
        }
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, paddingFactory(), xmarkButton, paddingFactory(), confirmButton])
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 10
        return view
    }()
    
    let viewModel: RideRequestViewModel
    
    init(viewModel: RideRequestViewModel) {
        self.viewModel = viewModel
        super.init(frame: .init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: RideRequestView.height))
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        xmarkButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.dismiss()
        }).disposed(by: disposeBag)
        
        confirmButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let rootNvc = self?.window?.rootViewController as? UINavigationController else { return }
            guard let mapView = rootNvc.viewControllers.compactMap({ $0 as? MainViewController }).first?.mapView else { return }
            self?.viewModel.confirmButtonTapped(mapView: mapView)
        }).disposed(by: disposeBag)
        
        viewModel.$isLoading.sink { [weak self] loading in
            self?.confirmButton.isEnabled = !loading
        }.store(in: &viewModel.subscriber)
        
        viewModel.$error.sink { [weak self] error in
            self?.makeToast(error?.localizedDescription)
        }.store(in: &viewModel.subscriber)
        
        viewModel.$requestSuccess.filter({ $0 }).sink { [weak self] _ in
            self?.delegate?.rideRequestSuccess()
            self?.dismiss()
        }.store(in: &viewModel.subscriber)
        
        viewModel.$placemark.sink { [weak self] place in
            self?.titleLabel.text = place.name
            self?.descriptionLabel.text = place.title
        }.store(in: &viewModel.subscriber)
    }
    
    private func configureUI() {
        layer.cornerRadius = 8
        backgroundColor = BackgroundColors.shared.primaryColor
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(15)
            make.centerX.equalTo(self)
        }
        present()
    }
    
    private func present() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.transform = .init(translationX: 0, y: -RideRequestView.height)
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.transform = .init(translationX: 0, y: 0)
        } completion: { _ in
            self.delegate?.rideRequestViewDismiss()
            self.removeFromSuperview()
        }
    }
}
