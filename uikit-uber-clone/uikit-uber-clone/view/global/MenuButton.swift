//
//  MenuButton.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/27.
//

import UIKit
import RxSwift

protocol MenuButtonDelegate: AnyObject {
    func menuButtonTapped(mode: MenuButton.ButtonType)
}

class MenuButton: UIButton {
    
    weak var delegate: MenuButtonDelegate?
    private let disposeBag = DisposeBag()
    
    enum ButtonType {
        case list
        case back
    }
    
    var mode: ButtonType = .list {
        didSet {
            switch mode {
            case .list: configuration?.image = .init(systemName: "list.dash")
            case .back: configuration?.image = .init(systemName: "xmark")
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let mode = self?.mode else { return }
            self?.delegate?.menuButtonTapped(mode: mode)
        }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        configuration = .plain()
        configuration?.image = .init(systemName: "list.dash")
        configuration?.baseBackgroundColor = nil
        configuration?.baseForegroundColor = .white
        snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }
}
