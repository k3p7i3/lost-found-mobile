import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    weak var delegate: MainViewController?
    
    private var mainMapView: MainMapView {
        return self.view as! MainMapView
    }
    private var annotations: ItemsOnMap?
    
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    
    override func loadView() {
        configureLocationManager()
        self.view = MainMapView(controller: self)
        annotations = ItemsOnMap(mapRect: mainMapView.getMapRegion())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainMapView.updateLocation(location: userLocation)
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        guard let annotations = self.annotations else { return }
        mapView.removeAnnotations(annotations.itemAnnonations)
        annotations.mapRect = mapView.region
        mapView.addAnnotations(annotations.itemAnnonations)
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let annotation = annotation as? ItemOnMap else { return }
        let itemViewController: ItemViewController = ItemViewController(item: annotation.item)
        itemViewController.modalPresentationStyle = .pageSheet
        present(itemViewController, animated: true, completion: nil)
    }
    
    func getUserLocation() -> CLLocation? {
        return userLocation
    }
}

extension MapViewController: NavBarDelegate {
    @objc func mapIconButtonGetPressed() {
    }
    
    @objc func userAccountButtonGetPressed() {
        delegate?.placeUserViewController()
    }
    
    @objc func addPostButtonGetPressed() {
        let itemCreateController: ItemCreateViewController = ItemCreateViewController()
        itemCreateController.modalPresentationStyle = .pageSheet
        present(itemCreateController, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            userLocation = location
            mainMapView.updateLocation(location: userLocation)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(error)
    }
}
