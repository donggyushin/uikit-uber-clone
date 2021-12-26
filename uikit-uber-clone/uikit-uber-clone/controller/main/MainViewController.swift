//
//  MainViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class MainViewController: BaseViewController {
    override func viewDidLoad() {
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = BackgroundColors.shared.primaryColor
    }
}
