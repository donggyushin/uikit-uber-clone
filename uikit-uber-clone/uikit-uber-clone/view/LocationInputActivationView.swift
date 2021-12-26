//
//  LocationInputActivationView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class LocationInputActivationView: UIView {
    
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.snp.makeConstraints { make in
            make.height.equalTo(6)
            make.width.equalTo(6)
        }
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    private let placeHolderLabel: UILabel = {
        let view = UILabel()
        view.text = "Where to go?"
        view.textColor = .darkGray
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .init(width: 1, height: 1)
        layer.masksToBounds = false
        clipsToBounds = false
        backgroundColor = .white
        snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.main.bounds.width - 36)
        }
        
        addSubview(dotView)
        dotView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(16)
        }
        
        addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(dotView.snp.right).offset(16)
        }
    }
}
