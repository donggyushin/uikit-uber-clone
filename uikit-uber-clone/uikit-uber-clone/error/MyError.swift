//
//  MyError.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Foundation

public enum MyError: Error {
    case unknown
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("알 수 없는 에러 발생", comment: "unknown")
        }
    }
}
