//
//  LocationTableView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit

class LocationTableView: UITableView {
    
    private let viewModel: LocationTableViewModel
    
    init(frame: CGRect, style: UITableView.Style, viewModel: LocationTableViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, style: style)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = BackgroundColors.shared.primaryColor
        alpha = 0
    }
    
    func present() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.frame.origin.y = LocationInputHeaderView.height
            self.alpha = 1
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.frame.origin.y = UIScreen.main.bounds.height
            self.alpha = 0
        }
    }
}

extension LocationTableView: LocationInputHeaderViewDelegate {
    func LocationInputHeaderViewSearchText(text: String) {
        viewModel.searchPlaces(query: text)
    }
}
