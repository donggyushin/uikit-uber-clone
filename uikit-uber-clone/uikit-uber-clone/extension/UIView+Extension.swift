//
//  UIView+Extension.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

extension UIView {
    func hide() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.alpha = 0
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.alpha = 1
        }
    }
}
