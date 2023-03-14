import Foundation
import MapKit

struct Item {
    var name: String
    var description: String
    var category: ItemCategory
    var returnWay: ItemReturn
    var authorId: Int
    
    //var createdAt: Date
    //var updatedAt: Date
    
    var itemId: Int? = Optional.none
    var place: CLLocationCoordinate2D? = Optional.none
    
    init() {
        name = ""
        description = ""
        category = ItemCategory.others
        returnWay = ItemReturn.other
        authorId = 0
        //createdAt = Date()
        //updatedAt = Date()
    }
    
    init(
        name: String,
        description: String,
        category: ItemCategory,
        returnWay: ItemReturn,
        //createdAt: Date,
        //updatedAt: Date,
        authorId: Int,
        place: CLLocationCoordinate2D
    ) {
        self.name = name
        self.description = description
        self.category = category
        self.returnWay = returnWay
        //self.createdAt = createdAt
        //self.updatedAt = updatedAt
        self.place = place
        self.authorId = authorId
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case category
        case return_way
        case author_id
        //case created_at
        //case updated_at
        case item_id
        case place
    }
    
    enum PlaceKeys: String, CodingKey {
        case address
        case coordinates
    }
    
    enum CoordinatesKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

extension Item: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        category = try values.decode(ItemCategory.self, forKey: .category)
        returnWay = try values.decode(ItemReturn.self, forKey: .return_way)
        authorId = try values.decode(Int.self, forKey: .author_id)
        //createdAt = try values.decode(Date.self, forKey: .created_at)
        //updatedAt = try values.decode(Date.self, forKey: .updated_at)
        
        itemId = try values.decode(Int.self, forKey: .item_id)
        
        if !values.contains(.place) {
            place = Optional.none
        } else {
            let coordinates = try values.nestedContainer(keyedBy: PlaceKeys.self, forKey: .place).nestedContainer(keyedBy: CoordinatesKeys.self, forKey: .coordinates)
            
            
            let latitude = try coordinates.decode(Double.self, forKey: .latitude)
            let longitude = try coordinates.decode(Double.self, forKey: .longitude)
            place = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}


struct ItemArray: Decodable {
    var array: [Item]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        array = try values.decode([Item].self, forKey: CodingKeys.items)
    }
}
