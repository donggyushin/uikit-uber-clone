//
//  MainViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit
import MapKit
import Firebase
import Combine

class MainViewController: BaseViewController {
    
    lazy var mapView: MKMapView = {
        let view = MKMapView(frame: view.frame)
        view.showsUserLocation = true
        view.userTrackingMode = .follow
        view.delegate = self
        return view
    }()
    private lazy var menuButton: MenuButton = {
        let view = MenuButton()
        view.delegate = self
        return view
    }()
    
    private let requestLoadingView = RequestLoadingView()
    
    private let activityView = LocationInputActivationView()
    private lazy var locationInputHeaderView: LocationInputHeaderView = .init(mainViewController: self)
    private lazy var locationTableView: LocationTableView = {
        let view = LocationTableView(frame: .init(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height - LocationInputHeaderView.height), style: .grouped, viewModel: DIViewModel.resolve().locationTableViewModelFactory(self.mapView.region), locationInputHeaderView: locationInputHeaderView)
        view.locationTableViewDelegate = self
        setScrollEnableOnKeyboards(target_scroll_views: [view])
        return view
    }()
    
    private let tempSignOutButton: BlueButton = {
        let view = BlueButton(buttonTitleText: "test sign out")
        return view
    }()
    
    private let floatingCenterButton = FloatingCenterButton()
    
    private let mainViewModel: MainViewModel
    private let linkUtil: LinkUtil
    private let mapKitUtik: MapKitUtil
    
    init(mainViewModel: MainViewModel, linkUtil: LinkUtil, mapKitUtik: MapKitUtil) {
        self.mainViewModel = mainViewModel
        self.linkUtil = linkUtil
        self.mapKitUtik = mapKitUtik
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
        
        floatingCenterButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.setCenter()
        }).disposed(by: disposeBag)
        
        tempSignOutButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            try? Auth.auth().signOut()
            self?.navigationController?.setViewControllers([DIViewController.resolve().loginViewControllerFactory()], animated: true)
        }).disposed(by: disposeBag)
        
        activityView.tap.rx.event.asDriver().drive(onNext: { [weak self] _ in
            self?.presentLocationSearchView()
        }).disposed(by: disposeBag)
        
        mainViewModel.$needLocationPermission.filter({ $0 }).sink { [weak self] _ in
            self?.openAppSetting()
        }.store(in: &subscriber)
        
        mainViewModel.$nearbyUsers.map({ $0.filter({ $0.userType == .DRIVER }) }).sink { [weak self] users in
            let new_annotations = users.compactMap({ $0.getDriverPointAnnotation() })
            let existing_annotations = self?.mapView.annotations.compactMap({ $0 as? DriverPointAnnotation }) ?? []
            
            new_annotations.forEach({ new in
                if existing_annotations.contains(where: { existing in
                    return existing.id == new.id
                }) == true {
                    // 해당 기존꺼를 업데이트 해준다.
                    if let existing = existing_annotations.first(where: { existing in
                        existing.id == new.id
                    }) {
                        existing.updateCoordinator(coordinate: new.coordinate)
                    }
                } else {
                    // 기존꺼에 포함되어져 있지 않다면,
                    self?.mapView.addAnnotation(new)
                }
            })
            
        }.store(in: &subscriber)
        
        mainViewModel.$destination.sink { [weak self] destination in
            self?.mapView.annotations.compactMap({ $0 as? DestinationPointAnnotation }).forEach({ self?.mapView.removeAnnotation($0) })
            guard let destination = destination else { return }
            self?.mapView.addAnnotation(destination)
            var annotations: [MKAnnotation] = []
            self?.mapView.annotations.compactMap({ $0 as? MKUserLocation }).forEach({ annotations.append($0) })
            annotations.append(destination)
            self?.mapView.fitAllAnnotations(annotations: annotations)
            self?.mapView.selectAnnotation(destination, animated: true)
        }.store(in: &subscriber)
        
        mainViewModel.$isUserCenter.sink { [weak self] center in
            self?.floatingCenterButton.isHidden = center
        }.store(in: &subscriber)
        
        mainViewModel.$error.compactMap({ $0 }).sink { [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        }.store(in: &subscriber)
        
        mainViewModel.$userTrackingMode.sink { [weak self] mode in
            switch mode {
            case .followWithHeading:
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    self?.activityView.transform = .init(translationX: 0, y: 30)
                }
            default:
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    self?.activityView.transform = .init(translationX: 0, y: 0)
                }
            }
        }.store(in: &subscriber)
        
        Publishers.CombineLatest(mainViewModel.$userType, mainViewModel.$myTripRequest).sink { [weak self] (usertype, mytripRequest) in
            let visible = (usertype == .RIDER) && (mytripRequest?.state != .requested)
            self?.activityView.isHidden = !visible
        }.store(in: &subscriber)
        
        mainViewModel.$trip.compactMap({ $0 }).filter({ $0.state == .requested}) .sink { [weak self] trip in
            let vc = DIViewController.resolve().pickupViewControllerFactory(trip)
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }.store(in: &subscriber)
        
        // Driver 기준
        mainViewModel.$trip.compactMap({ $0 }).filter({ $0.state == .accepted }).sink { [weak self] trip in
            print("[test] trip accepted!! \(trip)")
        }.store(in: &subscriber)
        
        // Rider 기준
        mainViewModel.$myTripRequest.sink(receiveValue: { [weak self] trip in
            self?.requestLoadingView.isHidden = trip?.state != .requested
        }).store(in: &subscriber)
    }
    
    private func configureUI() {
        
        locationInputHeaderView.delegate = locationTableView
        
        view.backgroundColor = BackgroundColors.shared.primaryColor
        view.addSubview(mapView)
        
        view.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view).offset(16)
        }
        
        view.addSubview(requestLoadingView)
        requestLoadingView.snp.makeConstraints { make in
            make.centerY.equalTo(menuButton)
            make.left.equalTo(menuButton.snp.right).offset(5)
        }
        
        view.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.top.equalTo(menuButton.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(tempSignOutButton)
        tempSignOutButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        view.addSubview(floatingCenterButton)
        floatingCenterButton.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        view.addSubview(locationInputHeaderView)
        locationInputHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
        view.addSubview(locationTableView)
    }
    
    private func presentRequestView(place: MKPlacemark) {
        let requestView = RideRequestView(viewModel: DIViewModel.resolve().rideRequestViewModelFactory(place))
        requestView.delegate = self
        view.addSubview(requestView)
    }
    
    private func openAppSetting() {
        let alert = UIAlertController(title: "위치 권한을 허용해주세요", message: "UBER 서비스를 이용하려면 위치 권한이 필수입니다. 위치 권한을 허용해주세요", preferredStyle: .alert)
        
        let action: UIAlertAction = .init(title: "설정", style: .default) { _ in
            self.linkUtil.openAppSetting()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func presentLocationSearchView() {
        self.activityView.hide()
        self.locationInputHeaderView.show()
        self.locationTableView.present()
    }
    
    func dismissLocationSearchView(showActivity: Bool) {
        if showActivity {
            self.activityView.show()
        }
        self.locationInputHeaderView.hide()
        self.locationTableView.dismiss()
    }
    
    private func setCenter() {
        self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mainViewModel.locationsUpdated(locations: locations)
    }
}

extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .init(cgColor: UIColor.systemPink.cgColor)
        renderer.lineWidth = 2
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mainViewModel.userTrackingMode = mapView.userTrackingMode
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mainViewModel.userTrackingMode = mapView.userTrackingMode
        mainViewModel.userMovedScreen(value: mapView.userTrackingMode.rawValue)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? DriverPointAnnotation else { return nil }
        let identifier = "DriverPointAnnotation"
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.image = .init(systemName: "car.fill")
        return view
    }
}

extension MainViewController: LocationTableViewDelegate {
    func locationTableViewSelectedPlace(place: MKPlacemark) {
        mapKitUtik.generateOverlays(placemark: place) { [weak self] result in
            switch result {
            case .success(let polylines):
                self?.mapView.addOverlays(polylines)
            case .failure(let error):
                self?.mainViewModel.error = error
            }
        }
        self.menuButton.mode = .back
        self.dismissLocationSearchView(showActivity: false)
        mainViewModel.setDestination(place: place)
        self.presentRequestView(place: place)
    }
}

extension MainViewController: MenuButtonDelegate {
    func menuButtonTapped(mode: MenuButton.ButtonType) {
        switch mode {
        case .back:
            self.dismissLocationSearchView(showActivity: true)
            self.setCenter()
            self.menuButton.mode = .list
            self.mainViewModel.destination = nil
            self.mapView.removeOverlays(self.mapView.overlays)
            self.view.subviews.compactMap({ $0 as? RideRequestView }).forEach({ $0.dismiss() })
        case .list:
            print("[test] 메뉴 보여주기")
        }
    }
}

extension MainViewController: RideRequestViewDelegate {
    func rideRequestSuccess() {
        print("[test] 요청 성공")
    }
    
    func rideRequestViewDismiss() {
        self.menuButtonTapped(mode: .back)
    }
}

extension MainViewController: PickupViewControllerDelegate {
    func didAcceptTrip(trip: Trip) {
        mainViewModel.trip = trip
    }
}
