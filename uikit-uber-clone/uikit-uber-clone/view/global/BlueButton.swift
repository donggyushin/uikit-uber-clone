//
//  BlueButton.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class BlueButton: UIButton {

    private let buttonTitleText: String
    
    init(buttonTitleText: String) {
        self.buttonTitleText = buttonTitleText
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        configuration = .tinted()
        configuration?.title = buttonTitleText
        configuration?.baseForegroundColor = .white
        configuration?.baseBackgroundColor = ButtonColors.shared.blue
        snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}
