import Foundation
import UIKit

class ItemCreateView: UIView {
    let sideMargin: Int = 35
    
    let nameField: UITextField = UITextField()
    let descriptionField: UITextView = UITextView()
    
    let enumsPicker: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    let imageView: UIImageView = UIImageView()
    
    let imageUploadButton: UIButton = UIButton()
    let pickLocationButton: UIButton = UIButton()
    let createPostButton: UIButton = UIButton()

    
    init(controller: ItemCreateViewController) {
        super.init(frame: .zero)
        
        setEnumsPicker()
        setDelegate(controller: controller)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setEnumsPicker() {
        enumsPicker.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        enumsPicker.register(ReturnWayCell.self, forCellWithReuseIdentifier: ReturnWayCell.reuseIdentifier)
    }
    
    private func setDelegate(controller: ItemCreateViewController) {
        enumsPicker.dataSource = controller
        enumsPicker.delegate = controller
        nameField.delegate = controller
        descriptionField.delegate = controller
        imageUploadButton.addTarget(
            controller,
            action: #selector(ItemCreateViewController.showImagePicker),
            for: .touchUpInside
        )
        pickLocationButton.addTarget(
            controller,
            action: #selector(LocationPickerDelegate.showLocationPicker),
            for: .touchUpInside
        )
        createPostButton.addTarget(
            controller,
            action: #selector(ItemCreateViewController.createNewItem),
            for: .touchUpInside
        )
    }
    
    private func setupNameLayout() {
        addSubview(nameField)
        nameField.backgroundColor = .systemGray6
        nameField.setLeftPaddingPoints(10)
        nameField.setRightPaddingPoints(10)
        nameField.layer.cornerRadius = 10
        nameField.placeholder = "Enter title"
        
        nameField.pin(to: self, [.left: sideMargin, .right: sideMargin, .top: 30])
        nameField.setHeight(40)
    }
    
    private func setupDescriptionLayout() {
        addSubview(descriptionField)
        descriptionField.backgroundColor = .systemGray6
        descriptionField.layer.cornerRadius = 10
        descriptionField.text = "Add description to your post"
        descriptionField.font = UIFont.systemFont(ofSize: 14)
        descriptionField.textColor = UIColor.lightGray
        
        descriptionField.pinTop(to: nameField.bottomAnchor, 20)
        descriptionField.pinLeft(to: self, sideMargin)
        descriptionField.pinRight(to: self, sideMargin)
        descriptionField.setHeight(120)
    }
    
    private func setupEnumsPickerLayout() {
        addSubview(enumsPicker)
        enumsPicker.pinTop(to: descriptionField.bottomAnchor, 5)
        enumsPicker.pinLeft(to: self, sideMargin)
        enumsPicker.pinRight(to: self, sideMargin)
        enumsPicker.setHeight(380)
    }
    
    private func setupImageUploadButton() {
        imageUploadButton.backgroundColor = Constants.mainBlueColor
        imageUploadButton.setTitle("Add image🖼️", for: .normal)
        imageUploadButton.setTitleColor(.white, for: .normal)
        imageUploadButton.layer.cornerRadius = 5
        imageUploadButton.setWidth(180)
    }
    
    private func setupPickLocationButton() {
        pickLocationButton.backgroundColor = Constants.mainBlueColor
        pickLocationButton.setTitle("Add location📍", for: .normal)
        pickLocationButton.setTitleColor(.white, for: .normal)
        pickLocationButton.layer.cornerRadius = 5
        pickLocationButton.setWidth(180)
    }
    
    private func setupCreatePostButton() {
        createPostButton.backgroundColor = UIColor.systemGreen
        createPostButton.setTitle("Create new post", for: .normal)
        createPostButton.setTitleColor(.white, for: .normal)
        createPostButton.layer.cornerRadius = 5
        createPostButton.setWidth(180)
    }
    
    private func setupImageView() {
        imageView.setWidth(130)
        imageView.setHeight(130)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    private func setupStackLayout() {
        
        let buttonStack: UIStackView = UIStackView(
            arrangedSubviews: [imageUploadButton, pickLocationButton, createPostButton]
        )
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        
        let imageStack: UIStackView = UIStackView(
            arrangedSubviews: [imageView, buttonStack]
        )
        addSubview(imageStack)
        imageStack.pinLeft(to: self, sideMargin)
        imageStack.pinRight(to: self, sideMargin)
        imageStack.pinTop(to: enumsPicker.bottomAnchor, 15)
        imageStack.axis = .horizontal
        imageStack.distribution = .equalSpacing
    }
    
    private func setupLayout() {
        backgroundColor = .white
        setupNameLayout()
        setupDescriptionLayout()
        setupEnumsPickerLayout()
        setupImageUploadButton()
        setupPickLocationButton()
        setupCreatePostButton()
        setupImageView()
        setupStackLayout()
    }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
