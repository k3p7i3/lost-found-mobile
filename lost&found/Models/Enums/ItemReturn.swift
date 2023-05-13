import Foundation

enum ItemReturn: String, Codable, CaseIterable {
    case contact
    case left
    case other
    
    func getDescriprion() -> String {
        switch self {
        case .contact:
            return "Contact the author to know the details"
        case .left:
            return "The item was left at the place where it was found"
        case .other:
            return "Author had to mention details in the description above"
        }
    }
}
