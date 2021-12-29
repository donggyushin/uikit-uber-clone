//
//  PickupViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/29.
//

import UIKit
import MapKit
import Firebase

protocol PickupViewControllerDelegate: AnyObject {
    func didAcceptTrip(trip: Trip)
}

class PickupViewController: BaseViewController {
    weak var delegate: PickupViewControllerDelegate?
    private let closeButton: UIButton = {
        let view = UIButton()
        view.setImage(.init(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        view.tintColor = .white
        return view
    }()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        view.snp.makeConstraints { make in
            make.width.equalTo(270)
            make.height.equalTo(270)
        }
        view.layer.cornerRadius = 270 / 2
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "Would you like to pick up this passenger?"
        view.textAlignment = .center
        view.textColor = FontsColor.shared.primaryColor
        return view
    }()
    
    private lazy var acceptButton: BlueButton = {
        let view = BlueButton(buttonTitleText: "ACCEPT")
        view.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 30)
        }
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mapView, descriptionLabel, acceptButton])
        view.axis = .vertical
        view.spacing = 30
        view.alignment = .center
        return view
    }()
    
    private let viewModel: PickupViewModel
    
    init(viewModel: PickupViewModel) {
        self.viewModel = viewModel
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
        closeButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        acceptButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.viewModel.acceptTrip()
        }).disposed(by: disposeBag)
        
        viewModel.$trip.sink { [weak self] trip in
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = trip.pickupCoordinates
            let region: MKCoordinateRegion = .init(center: trip.pickupCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self?.mapView.setRegion(region, animated: true)
            self?.mapView.addAnnotation(pointAnnotation)
            self?.mapView.setCenter(pointAnnotation.coordinate, animated: true)
        }.store(in: &subscriber)
        
        viewModel.$isLoading.sink { [weak self] loading in
            self?.acceptButton.isEnabled = !loading
        }.store(in: &subscriber)
        
        viewModel.$error.sink { [weak self] error in
            self?.view.makeToast(error?.localizedDescription)
        }.store(in: &subscriber)
        
        viewModel.$success.filter({ $0 }).sink { [weak self] _ in
            guard var trip = self?.viewModel.trip else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            trip.driverId = uid
            trip.state = .accepted
            self?.delegate?.didAcceptTrip(trip: trip)
            self?.dismiss(animated: true)
        }.store(in: &subscriber)
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view).offset(20)
        }
        
        view.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalTo(view)
        }
    }
}
