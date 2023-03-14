//
//  MapController.swift
//  lost&found
//
import UIKit
import MapKit

class MapController: UIViewController , MKMapViewDelegate {
    var mapView: MapView {
        return self.view as! MapView
    }
    var annotations: ItemsOnMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = MapView(controller: self)
        annotations = ItemsOnMap(mapRect: mapView.getMapRegion())
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        guard let annotations = self.annotations else { return }
        mapView.removeAnnotations(annotations.itemAnnonations)
        annotations.mapRect = mapView.region
        mapView.addAnnotations(annotations.itemAnnonations)
    }
}
