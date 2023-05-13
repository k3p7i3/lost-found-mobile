import Foundation
import UIKit

final class UserView: UIView {
    let avatarView: UIImageView = UIImageView()
    let nameLabel: UILabel = UILabel()
    let phoneNumberLabel: UILabel = UILabel()
    
    let addAvatarButton: UIButton = UIButton()
    let logoutButton: UIButton = UIButton()
    
    let navigationBar: NavigationBarView
    
    let userInfoStack: UIStackView = UIStackView()
    
    init(controller: UserViewController) {
        navigationBar = NavigationBarView(controller: controller)
        super.init(frame: UIScreen.main.bounds)
        setDelegate(controller: controller)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate(controller: UserViewController) {
        addAvatarButton.addTarget(
            controller,
            action: #selector(UserViewController.showImagePicker),
            for: .touchUpInside
        )
        logoutButton.addTarget(
            controller,
            action: #selector(UserViewController.logout),
            for: .touchUpInside
        )
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = Constants.mainTextColor
        nameLabel.font = .systemFont(ofSize: 22, weight: .medium)
    }
    
    private func setupPhoneNumber() {
        phoneNumberLabel.numberOfLines = 2
        phoneNumberLabel.textColor = .systemGray
        phoneNumberLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func setupAvatar() {
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.setWidth(125)
        avatarView.setHeight(125)
        avatarView.layer.cornerRadius = 62
    }
    
    private func setupStack() {
        setupNameLabel()
        setupPhoneNumber()
        setupAvatar()
        
        let textStack: UIStackView = UIStackView(
            arrangedSubviews: [nameLabel, phoneNumberLabel]
        )
        textStack.axis = .vertical
        textStack.alignment = .center
        textStack.distribution = .fillEqually
        textStack.spacing = 5
        
        userInfoStack.addArrangedSubview(avatarView)
        userInfoStack.addArrangedSubview(textStack)
        userInfoStack.axis = .horizontal
        userInfoStack.distribution = .equalSpacing
        addSubview(userInfoStack)
        userInfoStack.pin(to: self, [.left: 45, .right: 45, .top: 170])
    }
    
    private func setAddAvatarButton() {
        addSubview(addAvatarButton)
        addAvatarButton.backgroundColor = Constants.mainBlueColor
        addAvatarButton.setTitle("Change avatar", for: .normal)
        addAvatarButton.layer.cornerRadius = 10
        addAvatarButton.setHeight(40)
        addAvatarButton.setWidth(150)
        addAvatarButton.pinCenterX(to: self)
        addAvatarButton.pinTop(to: userInfoStack.bottomAnchor, 15)
    }
    
    private func setLogoutButton() {
        addSubview(logoutButton)
        logoutButton.backgroundColor = .systemRed
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.layer.cornerRadius = 10
        logoutButton.setHeight(30)
        logoutButton.setWidth(80)
        logoutButton.pinRight(to: self, 20)
        logoutButton.pinTop(to: self, 50)
        
    }
    
    private func setupLayout() {
        backgroundColor = .secondarySystemBackground
        setupStack()
        setAddAvatarButton()
        setLogoutButton()
        
        addSubview(navigationBar)
        navigationBar.setupExternalLayout()
    }
    
    func fillWithUserInfo(
        name: String,
        phoneNumber: String
    ) {
        nameLabel.text = name
        phoneNumberLabel.text = "Phone Number:\n" + phoneNumber
    }
    
    func watchOwnAccount() {
        addAvatarButton.isHidden = false
    }
    
    func watchStrangerAccount() {
        addAvatarButton.isHidden = true
    }
}
