//
//  MainViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit
import MapKit

class MainViewController: BaseViewController {
    
    private lazy var mapView = MKMapView(frame: view.frame)
    
    override func viewDidLoad() {
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = BackgroundColors.shared.primaryColor
        view.addSubview(mapView)
    }
}
