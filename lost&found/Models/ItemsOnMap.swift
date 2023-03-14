import Foundation
import MapKit

class ItemOnMap: NSObject, MKAnnotation {
    let itemId: Int
    var title: String?
    var subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(item: Item) {
        self.title = item.name
        self.subtitle = item.description
        self.coordinate = item.place ?? CLLocationCoordinate2D()
        self.itemId = item.itemId ?? 0
    }
}

class ItemsOnMap {
    var mapRect: MKCoordinateRegion {
        didSet {
            map?.removeAnnotations(itemAnnonations)
            fetchItemAnnotations()
            map?.addAnnotations(itemAnnonations)
        }
    }
    
    weak var map: MKMapView?
    
    var itemAnnonations: [MKAnnotation] = []
    
    init(mapRect: MKCoordinateRegion, map: MKMapView?) {
        self.mapRect = mapRect
        self.map = map
    }
    
    private func fetchItemAnnotations() {
        ApiService.shared.getItemsOnMap(mapRect: self.mapRect) { [weak self] result in
            switch result {
            case .success(let items):
                self?.itemAnnonations = items.compactMap { ItemOnMap(item: $0) }
                
            case .failure(let error):
                print(error)
            }
        }
            
    }
    
}
    

extension MKCoordinateRegion {
    var westLongitude: Double {
        get {
            return center.longitude - span.longitudeDelta / 2
        }
    }
    var eastLongitude: Double {
        get {
            return center.longitude + span.longitudeDelta / 2
        }
    }
    var southLatitude: Double {
        get {
            return center.latitude - span.latitudeDelta / 2
        }
    }
    var northLatitude: Double {
        get {
            return center.latitude + span.latitudeDelta / 2
        }
    }
}
