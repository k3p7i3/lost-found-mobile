import Foundation
import MapKit

final class ItemModel {
    var name: String
    var description: String? = Optional.none
    var category: ItemCategory
    var returnWay: ItemReturn
    var authorId: Int
    
    var createdAt: Date?
    var updatedAt: Date?
    
    var itemId: Int? = Optional.none
    var place: PlaceModel
    
    var imagePath: String? = Optional.none
    var image: UIImage? = Optional.none
    
    init(
        name: String,
        description: String,
        category: ItemCategory,
        returnWay: ItemReturn,
        authorId: Int,
        address: String,
        coordinates: CLLocationCoordinate2D,
        image: UIImage?
    ) {
        self.name = name
        self.description = description
        self.category = category
        self.returnWay = returnWay
        self.place = PlaceModel(address: address, coordinates: coordinates)
        self.authorId = authorId
        self.image = image
    }
    
    func getImageForView(for view: UIImageView) -> UIImage? {
        if let image = image {
            return image
        }
        
        guard let imagePath = imagePath else {
            image = UIImage(named: "EmptyPlaceholder")
            return image
        }
        
        weak var imageView: UIImageView? = view
        ApiService.shared.getItemImage(path: imagePath) { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
            default:
                self?.image = UIImage(named: "EmptyPlaceholder")
            }
            
            DispatchQueue.main.async() { [weak self] in
                imageView?.image = self?.image
            }
        }
        
        return self.image
    }
    
    func createItem() {
        ApiService.shared.createItem(item: self) { result in
            switch result {
            case .success(let id):
                self.itemId = id
                print(id)
                self.createItemImage()

            default:
                self.itemId = nil
            }
        }
    }
    
    func createItemImage() {
        if
            let id = itemId,
            let image = image
        {
            ApiService.shared.uploadItemImage(itemId: id, image: image) { [weak self] result in
                switch result {
                case .success(let path):
                    self?.imagePath = path
                default:
                    self?.imagePath = nil
                }
            }
        }
    }
    
    func isItemCreated() -> Bool {
        return itemId != nil
    }
}

extension ItemModel: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case category
        case returnWay = "return_way"
        case authorId = "author_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case itemId = "item_id"
        case place
        case imagePath = "image_path"
    }    
}


struct ItemArray: Decodable {
    var array: [ItemModel]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        array = try values.decode([ItemModel].self, forKey: CodingKeys.items)
    }
}
