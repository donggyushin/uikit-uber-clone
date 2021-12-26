//
//  UserError.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Foundation

public enum UserError: Error {
    case not_enought
    case no_uid
}

extension UserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .not_enought:
            return NSLocalizedString("정보를 모두 입력해주세요", comment: "not_enought")
        case .no_uid:
            return NSLocalizedString("로그인 해주세요.", comment: "no_uid")
        }
    }
}
