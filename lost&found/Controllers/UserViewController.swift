import Foundation
import UIKit
import Photos
import PhotosUI

final class UserViewController: UIViewController {
    var userView: UserView {
        return self.view as! UserView
    }
    
    var user: UserModel?
    var imagePicker: PHPickerViewController?
    
    weak var delegate: MainViewController?
    
    override func loadView() {
        self.view = UserView(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePicker()
    }
    
    func setImagePicker() {
        var configuration: PHPickerConfiguration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker?.delegate = self
    }
    
    func changeForUser(userId: Int) {
        user = UserModel(userId: userId)
        user?.getUser(userView: userView)
        
        if UserDefaults.standard.integer(forKey: "UserId") != userId {
            userView.watchStrangerAccount()
        } else {
            userView.watchOwnAccount()
        }
    }
    
    @objc
    func logout() {
        delegate?.setCurrentUserId(userId: 0)
        delegate?.placeLoginViewController()
    }
}

extension UserViewController: NavBarDelegate {
    @objc func mapIconButtonGetPressed() {
        delegate?.placeMapController()
    }
    
    @objc func userAccountButtonGetPressed() {
    }
    
    @objc func addPostButtonGetPressed() {
        let itemCreateController: ItemCreateViewController = ItemCreateViewController()
        itemCreateController.modalPresentationStyle = .pageSheet
        present(itemCreateController, animated: true, completion: nil)
    }
}

extension UserViewController: PHPickerViewControllerDelegate {
    @objc func showImagePicker() {
        if let picker = imagePicker {
            present(picker, animated: true)
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if
                    let image = image as? UIImage,
                    let user = self?.user
                {
                    user.createAvatar(image: image)
                    DispatchQueue.main.async() { [weak self] in
                        self?.userView.avatarView.image = image
                    }
                } else {
                    print(error ?? "")
                }
            }
        }
    }
}
