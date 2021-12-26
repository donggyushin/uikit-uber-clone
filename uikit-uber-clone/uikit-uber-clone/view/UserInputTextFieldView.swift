//
//  UserInputTextFieldView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class UserInputTextFieldView: UIView {
    
    private let iconImageString: String
    private let placeholderString: String
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView(image: .init(systemName: self.iconImageString))
        view.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        view.contentMode = .scaleAspectFit
        view.setImageColor(color: .white)
        view.alpha = 0.87
        return view
    }()
    
    lazy var tf: UITextField = {
        let view = UITextField()
        view.borderStyle = .none
        view.font = .systemFont(ofSize: 16)
        view.textColor = .white
        view.keyboardAppearance = .dark
        view.attributedPlaceholder = NSAttributedString(string: self.placeholderString, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        view.autocapitalizationType = .none
        return view
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }()
    
    init(iconImageString: String, placeholderString: String) {
        self.iconImageString = iconImageString
        self.placeholderString = placeholderString
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        
        addSubview(tf)
        tf.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.centerY.equalTo(iconImageView)
            make.right.equalTo(self)
        }
        
        addSubview(underLine)
        underLine.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(tf.snp.bottom).offset(12)
            make.bottom.equalTo(self)
        }
    }
}
