//
//  MapView.swift
//  lost&found
//
//  Created by Polina Kopyrina on 14.03.2023.
//

import Foundation
import UIKit
import MapKit

public class MapView: UIView {
    private var mapView: MKMapView = MKMapView()
    
    init(controller: MapController) {
        mapView.delegate = controller
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .white
        setupMapView()
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMapView() {
        mapView.isRotateEnabled = false
        addSubview(mapView)
        mapView.pin(to: self, [.top: 0, .left: 0, .right: 0, .bottom: 0])
        let initialLocation = CLLocation(latitude: 55.753226, longitude: 37.648464)
        mapView.centerToLocation(initialLocation)
    }
    
    func getMapRegion() -> MKCoordinateRegion {
        return mapView.region
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
      
    setRegion(coordinateRegion, animated: true)
  }
}

