//
//  BaseViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift

class BaseViewModel {
    let isLoading: BehaviorSubject<Bool> = .init(value: false)
    let error: BehaviorSubject<Error?> = .init(value: nil)
    let disposeBag = DisposeBag()
}
