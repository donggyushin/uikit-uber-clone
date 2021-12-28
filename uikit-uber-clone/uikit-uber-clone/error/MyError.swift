//
//  MyError.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Foundation

public enum MyError: Error {
    case unknown
    case unauthorized
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown: return NSLocalizedString("알 수 없는 에러 발생", comment: "unknown")
        case .unauthorized: return NSLocalizedString("인증 정보에 문제가 생겼습니다. 앱 종료후에 다시 실행해주세요.", comment: "unauthorized")
        }
    }
}
