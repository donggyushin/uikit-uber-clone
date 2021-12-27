//
//  DIUtil.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/27.
//

struct DIUtil {
    let linkUtil: LinkUtil
    let mapKitUtil: MapKitUtil
}

extension DIUtil {
    static func resolve() -> DIUtil {
        
        let linkUtil: LinkUtil = LinkUtil.shared
        let mapKitUtil: MapKitUtil = MapKitUtil.shared
        
        return .init(linkUtil: linkUtil, mapKitUtil: mapKitUtil)
    }
}
