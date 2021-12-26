//
//  LocationInputTextField.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class LocationInputTextField: UITextField {
    
    private let placeHolderText: String
    
    private let paddingView: UIView = {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        return view
    }()
    
    init(placeHolderText: String) {
        self.placeHolderText = placeHolderText
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        leftView = paddingView
        leftViewMode = .always
        backgroundColor = .darkGray
        placeholder = placeHolderText
        returnKeyType = .search
        snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
}
