import Foundation
import UIKit

class UserModel: Codable {
    var name: String?
    var phoneNumber: String?
    var password: String?
    var userId: Int?
    var avatarPath: String?
    
    var avatar: UIImage?
    
    init(userId: Int) {
        self.userId = userId
    }
    
    
    init(name: String?, phoneNumber: String, password: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.password = password
        self.userId = Optional.none
    }
    
    
    func getUser(userView: UserView?) {
        guard let userId = userId else { return }
        ApiService.shared.getUserByID(userId: userId) { [weak self] result in
            switch result {
            case .success(let user):
                
                self?.name = user.name
                self?.phoneNumber = user.phoneNumber
                self?.avatarPath = user.avatarPath
                if
                    let userView = userView,
                    let name = user.name,
                    let phoneNumber = user.phoneNumber
                {
                    DispatchQueue.main.async() {
                        userView.fillWithUserInfo(
                            name: name,
                            phoneNumber: phoneNumber
                        )
                    }
                    self?.getAvatarForView(for: userView.avatarView)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @discardableResult
    func getAvatarForView(for view: UIImageView) -> UIImage? {
        if let image = avatar {
            return image
        }
        
        guard let avatarPath = avatarPath else {
            avatar = UIImage(named: "EmptyPlaceholder")
            DispatchQueue.main.async() { [weak self] in
                view.image = self?.avatar
            }
            return avatar
        }
        
        weak var avatarView: UIImageView? = view
        ApiService.shared.getUserImage(path: avatarPath) { [weak self] result in
            switch result {
            case .success(let image):
                self?.avatar = image
            default:
                self?.avatar = UIImage(named: "EmptyPlaceholder")
            }
            
            DispatchQueue.main.async() { [weak self] in
                avatarView?.image = self?.avatar
            }
        }
        
        return self.avatar
    }
    
    func createAvatar(image: UIImage) {
        if let id = userId {
            ApiService.shared.uploadUserImage(userId: id, image: image) { [weak self] result in
                switch result {
                case .success(let path):
                    self?.avatarPath = path
                default:
                    self?.avatarPath = nil
                }
            }
            self.avatar = image
        }
    }
    
    func loginUser(controller: LoginViewController) {
        ApiService.shared.loginUser(user: self) { [weak self] result in
            switch result {
            case .success(let resultUser):
                self?.userId = resultUser.userId
                self?.name = resultUser.name
                self?.phoneNumber = resultUser.phoneNumber
                self?.avatarPath = resultUser.avatarPath
                if let id = resultUser.userId {
                    DispatchQueue.main.async() {
                        controller.successLogin(with: id)
                    }
                }
            default:
                DispatchQueue.main.async() {
                    controller.failLogin()
                }
            }
        }
    }
    
    func registrateUser(controller: RegistrationViewController) {
        ApiService.shared.registrateUser(user: self) { [weak self] result in
            switch result {
            case .success(let userId):
                self?.userId = userId
                DispatchQueue.main.async() {
                    controller.successRegistration(with: userId)
                }
            default:
                DispatchQueue.main.async() {
                    controller.failRegistration()
                }
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone_number"
        case password
        case userId = "user_id"
        case avatarPath = "avatar_path"
    }
}
