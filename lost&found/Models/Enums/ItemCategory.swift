import Foundation
import UIKit

enum ItemCategory: String, Codable, CaseIterable {
    case phones
    case keys
    case documents
    case wallets
    case accessories
    case others
    
    static let allValues = [phones, keys, documents, wallets, accessories, others]
}

