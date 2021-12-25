//
//  BaseViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        navigationController?.navigationBar.barStyle = .black
    }

}
