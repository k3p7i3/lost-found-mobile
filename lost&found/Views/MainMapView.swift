import Foundation
import UIKit
import MapKit

class MainMapView: UIView {
    let mapView: MapView
    
    init(controller: MapViewController, frame: CGRect = UIScreen.main.bounds) {
        mapView = MapView(controller: controller)
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(mapView)
        mapView.setupExternalLayout()
    }
    
    func updateLocation(location: CLLocation?) {
        if let location = location {
            mapView.centerToLocation(location)
        } else {
            mapView.centerToLocation(Constants.baseLocation, regionRadius: 2000)
        }
    }
    
    func getMapRegion() -> MKCoordinateRegion {
        return mapView.region
    }
}
