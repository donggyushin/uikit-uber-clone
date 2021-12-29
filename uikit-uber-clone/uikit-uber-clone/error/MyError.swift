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
    case tripCancelled
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown: return NSLocalizedString("unknown error occred", comment: "unknown")
        case .unauthorized: return NSLocalizedString("Authorization issue. Please restart the app.", comment: "unauthorized")
        case .tripCancelled: return NSLocalizedString("Request just got cancelled", comment: "tripCancelled")
        }
    }
}
