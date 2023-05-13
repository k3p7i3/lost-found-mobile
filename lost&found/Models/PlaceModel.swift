import Foundation
import MapKit

struct PlaceModel {
    var address: String
    var coordinates: CLLocationCoordinate2D
    
    init(address: String, coordinates: CLLocationCoordinate2D) {
        self.address = address
        self.coordinates = coordinates
    }
}

extension PlaceModel : Codable {
    enum PlaceKeys: String, CodingKey {
        case address
        case coordinates
    }
    
    enum CoordinatesKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PlaceKeys.self)
        
        address = try values.decode(String.self, forKey: .address)
        
        let coordinatesValues = try values.nestedContainer(keyedBy: CoordinatesKeys.self, forKey: .coordinates)
        let latitude = try coordinatesValues.decode(Double.self, forKey: .latitude)
        let longitude = try coordinatesValues.decode(Double.self, forKey: .longitude)
        
        coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PlaceKeys.self)
        try container.encode(address, forKey: .address)
        
        var coordinatesContainer = container
            .nestedContainer(keyedBy: CoordinatesKeys.self, forKey: .coordinates)
        try coordinatesContainer.encode(coordinates.latitude, forKey: .latitude)
        try coordinatesContainer.encode(coordinates.longitude, forKey: .longitude)
    }
}
