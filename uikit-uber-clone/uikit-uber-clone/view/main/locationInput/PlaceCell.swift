//
//  PlaceCell.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit
import MapKit

class PlaceCell: UITableViewCell {
    
    static let identifier = "PlaceCellIdentifier"
    
    var place: MKPlacemark? {
        didSet {
            guard let place = place else { return }
            self.configureUI(place: place)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = FontsColor.shared.primaryColor
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
    private func configureUI(place: MKPlacemark) {
        titleLabel.text = place.name
        descriptionLabel.text = place.title
    }
}
