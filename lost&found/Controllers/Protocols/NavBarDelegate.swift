import Foundation

@objc protocol NavBarDelegate: AnyObject {
    func mapIconButtonGetPressed()
    func userAccountButtonGetPressed()
    
    func addPostButtonGetPressed()
}
