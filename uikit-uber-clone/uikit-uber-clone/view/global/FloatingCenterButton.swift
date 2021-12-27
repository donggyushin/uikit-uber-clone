//
//  FloatingCenterButton.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/27.
//

import UIKit

class FloatingCenterButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        configuration = .tinted()
        configuration?.image = .init(systemName: "target")
        configuration?.baseForegroundColor = .systemPink
        configuration?.baseBackgroundColor = .purple
        configuration?.cornerStyle = .capsule
        snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
    }
}
