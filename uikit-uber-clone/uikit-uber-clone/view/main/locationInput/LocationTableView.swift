//
//  LocationTableView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import UIKit
import Combine
import MapKit

protocol LocationTableViewDelegate: AnyObject {
    func locationTableViewSelectedPlace(place: MKPlacemark)
}

class LocationTableView: UITableView {
    
    private let viewModel: LocationTableViewModel
    private let locationInputHeaderView: LocationInputHeaderView
    private var subscriber: Set<AnyCancellable> = .init()
    weak var locationTableViewDelegate: LocationTableViewDelegate?
    
    init(frame: CGRect, style: UITableView.Style, viewModel: LocationTableViewModel, locationInputHeaderView: LocationInputHeaderView) {
        self.viewModel = viewModel
        self.locationInputHeaderView = locationInputHeaderView
        super.init(frame: frame, style: style)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.$places.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.reloadData()
            }
        }.store(in: &subscriber)
    }
    
    private func configureUI() {
        separatorStyle = .none
        register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.identifier)
        backgroundColor = BackgroundColors.shared.primaryColor
        delegate = self
        dataSource = self 
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

extension LocationTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        locationInputHeaderView.destinationTextFieldView.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
        locationTableViewDelegate?.locationTableViewSelectedPlace(place: viewModel.places[indexPath.row])
    }
}

extension LocationTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Favorites" : "Places"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : viewModel.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier, for: indexPath) as? PlaceCell ?? PlaceCell()
        
        if indexPath.section == 1 {
            cell.place = viewModel.places[indexPath.row]
        }
        
        return cell
    }
}
