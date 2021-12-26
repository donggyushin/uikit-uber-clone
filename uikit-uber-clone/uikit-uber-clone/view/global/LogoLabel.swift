//
//  LogoLabel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class LogoLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .init(name: "Avenir-Light", size: 36)
        textColor = FontsColor.shared.primaryColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
