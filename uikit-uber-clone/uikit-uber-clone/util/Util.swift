//
//  Util.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class Util {
    static let shared = Util()
    
    func openAppSetting() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
}
