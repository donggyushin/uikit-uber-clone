//
//  BaseViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift
import Combine

class BaseViewModel {
    @Published var isLoading = false
    @Published var error: Error? = nil
    let disposeBag = DisposeBag()
    var subscriber: Set<AnyCancellable> = .init()
}
