//
//  RequestLoadingView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/29.
//

import UIKit

class RequestLoadingView: UIView {
    
    private let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.startAnimating()
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = FontsColor.shared.primaryColor
        view.text = "requesting...."
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        
        let view = UIStackView(arrangedSubviews: [indicator, descriptionLabel])
        view.spacing = 20
        view.axis = .horizontal
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
