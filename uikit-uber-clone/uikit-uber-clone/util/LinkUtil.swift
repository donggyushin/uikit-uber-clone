//
//  LinkUtil.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/27.
//

import UIKit

class LinkUtil {
    static let shared = LinkUtil()
    func openAppSetting() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
}
