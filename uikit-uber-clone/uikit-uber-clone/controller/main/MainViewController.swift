//
//  MainViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit
import MapKit

class MainViewController: BaseViewController {
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView(frame: view.frame)
        view.showsUserLocation = true
        view.userTrackingMode = .follow
        return view
    }()
    
    private let activityView = LocationInputActivationView()
    
    private let mainViewModel: MainViewModel
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureUI()
        bind()
        mainViewModel.locationManager.delegate = self
    }
    
    private func bind() {
        mainViewModel.needLocationPermission.asDriver(onErrorJustReturn: false).filter({ $0 }).drive(onNext: { [weak self] _ in
            self?.openAppSetting()
        }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = BackgroundColors.shared.primaryColor
        view.addSubview(mapView)
        
        view.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalTo(view)
        }
    }
    
    private func openAppSetting() {
        let alert = UIAlertController(title: "위치 권한을 허용해주세요", message: "UBER 서비스를 이용하려면 위치 권한이 필수입니다. 위치 권한을 허용해주세요", preferredStyle: .alert)
        
        let action: UIAlertAction = .init(title: "설정", style: .default) { _ in
            Util.shared.openAppSetting()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mainViewModel.locationsUpdated(locations: locations)
    }
}
