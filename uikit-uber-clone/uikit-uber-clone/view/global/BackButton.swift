//
//  BackButton.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class BackButton: UIButton {
    
    private let size: CGFloat = 50
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let image: UIImage = .init(systemName: "xmark")?.withRenderingMode(.alwaysTemplate) ?? .init()
        setImage(image, for: .normal)
        tintColor = FontsColor.shared.primaryColor
        snp.makeConstraints { make in
            make.width.equalTo(size)
            make.height.equalTo(size)
        }
    }
}
