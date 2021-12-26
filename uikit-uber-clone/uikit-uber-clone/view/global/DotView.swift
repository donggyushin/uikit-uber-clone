//
//  DotView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class DotView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        snp.makeConstraints { make in
            make.height.equalTo(6)
            make.width.equalTo(6)
        }
        layer.cornerRadius = 3
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}
