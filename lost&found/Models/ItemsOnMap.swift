import Foundation
import MapKit

class ItemOnMap: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let item: ItemModel
    
    init(item: ItemModel) {
        self.title = item.name
        self.coordinate = item.place.coordinates
        self.item = item
    }
}

class ItemsOnMap {
    var mapRect: MKCoordinateRegion {
        didSet {
            fetchItemAnnotations()
        }
    }
    
    var itemAnnonations: [MKAnnotation] = []
    
    init(mapRect: MKCoordinateRegion) {
        self.mapRect = mapRect
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
