//
//  MKMapView+Extension.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/27.
//

import MapKit

extension MKMapView {
    func fitAllAnnotations(annotations: [MKAnnotation]) {
        var zoomRect = MKMapRect.null
        annotations.map({ MKMapPoint($0.coordinate) }).map({ MKMapRect(x: $0.x, y: $0.y, width: 0.1, height: 0.1) }).forEach({ zoomRect = zoomRect.union($0) })
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 300, right: 100), animated: true)
    }
}
