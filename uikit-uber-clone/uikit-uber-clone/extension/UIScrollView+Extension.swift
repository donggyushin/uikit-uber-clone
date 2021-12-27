//
//  UIScrollView+Extension.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/28.
//

import UIKit
extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        guard contentSize.height > bounds.size.height else { return }

        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}
