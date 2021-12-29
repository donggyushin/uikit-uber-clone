//
//  MatchedViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/29.
//

import UIKit
import MapKit

class MatchedViewController: BaseViewController {
    
    weak var delegate: PickupViewControllerDelegate?
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView(frame: view.frame)
        view.showsUserLocation = true
        view.userTrackingMode = .follow
        view.delegate = self
        return view
    }()
    
    private let floatingCancelButton = FloatingCancelButton()
    
    private let viewModel: MatchedViewModel
    
    init(viewModel: MatchedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        configureUI()
        bind()
    }
    
    private func bind() {
        
        floatingCancelButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.presentCancelAlert()
        }).disposed(by: disposeBag)
        
        viewModel.$isLoading.sink { [weak self] loading in
            self?.floatingCancelButton.isEnabled = !loading
        }.store(in: &subscriber)
        
        viewModel.$error.sink { [weak self] error in
            self?.view.makeToast(error?.localizedDescription)
        }.store(in: &subscriber)
        
        viewModel.$trip.sink { [weak self] trip in
            print("[test] 여기서 trip annotation 꽂아주어야 함")
        }.store(in: &subscriber)
        
        viewModel.$trip.filter({ $0.state == .canceled }).sink { [weak self] _ in
            let error: MyError = .tripCancelled
            self?.delegate?.tripCancelled(error: error)
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &subscriber)
    }
    
    private func configureUI() {
        view.backgroundColor = BackgroundColors.shared.primaryColor
        
        view.addSubview(mapView)
        
        view.addSubview(floatingCancelButton)
        floatingCancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view).offset(20)
        }
    }
    
    private func presentCancelAlert() {
        let alert = UIAlertController(title: nil, message: "Are you sure want to cancel your request?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "yes", style: .default) { _ in
            self.viewModel.cancelButtonTapped()
        }
        let no = UIAlertAction(title: "no", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MatchedViewController: MKMapViewDelegate {
    
}
