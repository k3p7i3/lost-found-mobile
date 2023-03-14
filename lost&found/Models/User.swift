import Foundation

struct User: Codable {
    var name: String
    var phoneNumber: String
    var password: String?
    var userId: Int?
    
    init() {
        name = ""
        phoneNumber = ""
        password = Optional.none
        userId = Optional.none
    }
    
    init(name: String, phoneNumber: String, password: String?) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.password = password
        self.userId = Optional.none
    }
}
