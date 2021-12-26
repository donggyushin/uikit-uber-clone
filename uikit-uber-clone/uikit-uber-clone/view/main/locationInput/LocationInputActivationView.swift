//
//  LocationInputActivationView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class LocationInputActivationView: UIView {
    
    private let dotView = DotView()
    
    private let placeHolderLabel: UILabel = {
        let view = UILabel()
        view.text = "Where to go?"
        view.textColor = .darkGray
        return view
    }()
    
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        return tap
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
        
        alpha = 0
        show()
    }
}
