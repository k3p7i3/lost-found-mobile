
import Foundation
import UIKit
import MapKit


public class MapView: MKMapView {
    private let navigationBar: NavigationBarView
    
    init(controller: MapViewController, frame: CGRect = UIScreen.main.bounds) {
        navigationBar = NavigationBarView(controller: controller)
        super.init(frame: frame)
        delegate = controller
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar() {
        addSubview(navigationBar)
        navigationBar.setupExternalLayout()
    }
    
    private func setupLayout() {
        isRotateEnabled = false
        setupNavigationBar()
    }
    
    func setupExternalLayout() {
        guard let superview = superview else { return }
        pin(to: superview, [.top: 0, .bottom: 0, .left: 0, .right: 0])
    }
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
}
