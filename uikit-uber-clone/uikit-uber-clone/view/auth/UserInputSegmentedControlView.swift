//
//  UserInputSegmentedControlView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class UserInputSegmentedControlView: UIView {
    private let iconImageString: String
    private let option1Text: String
    private let option2Text: String
    
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
    
    lazy var segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: [option1Text, option2Text])
        view.backgroundColor = BackgroundColors.shared.primaryColor
        view.tintColor = FontsColor.shared.primaryColor
        view.selectedSegmentIndex = 0 
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
    
    init(iconImageString: String, option1Text: String, option2Text: String) {
        self.iconImageString = iconImageString
        self.option1Text = option1Text
        self.option2Text = option2Text
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
        
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.right.equalTo(self)
        }
        
        addSubview(underLine)
        underLine.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(12)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
