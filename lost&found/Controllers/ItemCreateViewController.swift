import Foundation
import UIKit
import Photos
import PhotosUI

class ItemCreateViewController: UIViewController {
    let categoryValues: [ItemCategory] = ItemCategory.allCases.map{$0}
    let returnWayValues: [ItemReturn] = ItemReturn.allCases.map{$0}
    
    var enumsView: UICollectionView?
    var selectedCategories: [IndexPath] = []
    var selectedReturnWays: [IndexPath] = []
    
    var imagePicker: PHPickerViewController?
    var locationPicker: LocationPickerController?
    
    // values for future item object
    private var itemName: String?
    private var itemDescription: String?
    private var itemCategory: ItemCategory?
    private var itemReturn: ItemReturn?
    private var itemImage: UIImage?
    private var itemCoordinates: CLLocationCoordinate2D?
    
    
    var formView: ItemCreateView {
        return self.view as! ItemCreateView
    }
    
    override func loadView() {
        self.view = ItemCreateView(controller: self)
        enumsView = formView.enumsPicker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePicker()
        locationPicker = LocationPickerController()
        locationPicker?.delegate = self
        
    }
    
    func setImagePicker() {
        var configuration: PHPickerConfiguration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker?.delegate = self
    }
    
    @objc
    func createNewItem() {
        if
            let name = itemName,
            let category = itemCategory,
            let returnWay = itemReturn,
            let coordinates = itemCoordinates
        {
            let item: ItemModel = ItemModel(
                name: name,
                description: itemDescription ?? "",
                category: category,
                returnWay: returnWay,
                authorId: UserDefaults.standard.integer(forKey: "UserId"),
                address: "",
                coordinates: coordinates,
                image: itemImage
            )
            item.createItem()
            self.dismiss(animated: true)
        } else {
            alert(message: "Fill required fields to create new post.", title: "Creation error.")
        }
    }
    
    func alert(message: String, title: String = "") {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(OKAction)
      self.present(alertController, animated: true, completion: nil)
    }

}

extension ItemCreateViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        if section == 0 {
            return categoryValues.count
        } else {
            return returnWayValues.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            if let categoryCell = enumsView?.dequeueReusableCell(
                withReuseIdentifier: CategoryCell.reuseIdentifier,
                for: indexPath
            ) as? CategoryCell {
                categoryCell.configure(with: categoryValues[indexPath.row])
                return categoryCell
            }
        default:
            if let returnWayCell = enumsView?.dequeueReusableCell(
                withReuseIdentifier: ReturnWayCell.reuseIdentifier,
                for: indexPath
            ) as? ReturnWayCell {
                returnWayCell.configure(with: returnWayValues[indexPath.row])
                return returnWayCell
            }
        }
        return UICollectionViewCell()
    }
    
}

extension ItemCreateViewController: UICollectionViewDelegate {
    
    func deselectCell(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let categoryCell = enumsView?.cellForItem(at: indexPath) as? CategoryCell {
                categoryCell.deselectLayout()
            }

            return
        default:
            itemReturn = returnWayValues[indexPath.row]

            if let returnWayCell = enumsView?.cellForItem(at: indexPath) as? ReturnWayCell {
                returnWayCell.deselectLayout()
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        
        let item = collectionView.cellForItem(at: indexPath)
        if item?.isSelected ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            
            switch indexPath.section {
            case 0:
                if selectedCategories.count == 1 {
                    deselectCell(indexPath: selectedCategories[0])
                    collectionView.deselectItem(at: selectedCategories[0], animated: false)
                    selectedCategories.removeFirst()
                }
            default:
                if selectedReturnWays.count == 1 {
                    deselectCell(indexPath: selectedReturnWays[0])
                    collectionView.deselectItem(at: selectedReturnWays[0], animated: false)
                    selectedReturnWays.removeFirst()
                }
            }
            
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            return true
        }

        return false
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 0:
            itemCategory = categoryValues[indexPath.row]
            
            if let categoryCell = enumsView?.cellForItem(at: indexPath) as? CategoryCell {
                categoryCell.selectLayout()
            }
            
            selectedCategories.append(indexPath)
            return
            
        default:
            itemReturn = returnWayValues[indexPath.row]
            
            if let returnWayCell = enumsView?.cellForItem(at: indexPath) as? ReturnWayCell {
                returnWayCell.selectLayout()
            }
            selectedReturnWays.append(indexPath)
        }
    }
    
    
}

extension ItemCreateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let cellWidth: CGFloat
            let cellHeight: CGFloat
            
            if indexPath.section == 0 {
                cellWidth = 130
                cellHeight = 30
            } else {
                if let enumsView = enumsView {
                    cellWidth = enumsView.frame.size.width - 60
                } else {
                    cellWidth = UIScreen.main.bounds.width - 60
                }
                cellHeight = 60
                
            }
            return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
           return UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        }
}

extension ItemCreateViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        itemName = textField.text
    }
}

extension ItemCreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = Constants.mainTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        itemDescription = textView.text
        if textView.text.isEmpty {
            textView.text = "Add description to your post"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

extension ItemCreateViewController: PHPickerViewControllerDelegate {
    @objc func showImagePicker() {
        if let picker = imagePicker {
            present(picker, animated: true)
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss (animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if let image = image as? UIImage {
                    self?.itemImage = image
                    DispatchQueue.main.async() { [weak self] in
                        self?.formView.imageView.image = image
                    }
                } else {
                    print(error ?? "")
                }
            }
        }
    }
}

extension ItemCreateViewController: LocationPickerDelegate {
    @objc func showLocationPicker() {
        if let picker = locationPicker {
            picker.modalPresentationStyle = .pageSheet
            present(picker, animated: true)
        }
    }
    
    func didPickLocation(coordinate: CLLocationCoordinate2D) {
        self.itemCoordinates = coordinate
    }
    
    func closeLocationPicker() {
        locationPicker?.dismiss(animated: true)
    }
}

