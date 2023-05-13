import Foundation
import UIKit
import MapKit

class LocationPickerController: UIViewController {
    var mapView: PickLocationMapView {
        return self.view as! PickLocationMapView
    }
    weak var delegate: ItemCreateViewController?
    
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    
    override func loadView() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let padding: CGFloat = 30
        self.view = PickLocationMapView(
            controller: self,
            initLocation: userLocation,
            frame: CGRect(
                x: padding,
                y: padding,
                width: screenSize.width - padding,
                height: screenSize.height - padding
            )
        )
        mapView.layer.cornerRadius = 20
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        if mapView.annotations.count == 1 {
            mapView.removeAnnotation(mapView.annotations.last!)
        }
        mapView.addAnnotation(annotation)
        
        delegate?.didPickLocation(coordinate: coordinate)
    }
    
    @objc
    func didEndPickLocation() {
        delegate?.closeLocationPicker()
    }
}

extension LocationPickerController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            userLocation = location
            mapView.centerToLocation(location)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(error)
    }
}

