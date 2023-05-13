import Foundation
import UIKit

class ItemView: UIView {
    let imageView = UIImageView()
    let sideMargin: Int = 35
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let categoryLabel = UILabel()
    let returnLabel = UILabel()
    let dateLabel = UILabel()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(descriptionLabel)
        addSubview(returnLabel)
        addSubview(dateLabel)
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(for item: ItemModel) {
        backgroundColor = .white
        setImageView(for: item)
        setNameLabel(name: item.name)
        setCategoryLabel(category: item.category)
        setDecriptionLabel(description: item.description)
        setReturnLabel(returnWay: item.returnWay)
        if let createdAt = item.createdAt {
            setDateLabel(date: createdAt)
        }
        
    }
    
    private func setImageView(for item: ItemModel) {
        if let image = item.getImageForView(for: self.imageView) {
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.pinTop(to: self, 0)
        imageView.pinLeft(to: self, 0)
        imageView.pinRight(to: self, 0)
        imageView.setHeight(320)
    }
    
    private func setNameLabel(name: String) {
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 24, weight: .medium)
        nameLabel.textColor = Constants.mainTextColor
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        
        nameLabel.pinTop(to: imageView.bottomAnchor, 30)
        nameLabel.pinLeft(to: self, sideMargin)
        nameLabel.pinWidth(to: self, 0.45)
    }
    
    private func setCategoryLabel(category: ItemCategory) {
        categoryLabel.text = category.rawValue
        categoryLabel.font = .systemFont(ofSize: 15, weight: .medium)
        categoryLabel.textColor = .white
        categoryLabel.textAlignment = .center
        categoryLabel.backgroundColor = Constants.mainBlueColor
        categoryLabel.layer.masksToBounds = true
        categoryLabel.layer.cornerRadius = 5
        
        
        categoryLabel.setHeight(27)
        categoryLabel.setWidth(115)
        categoryLabel.pinTop(to: nameLabel.bottomAnchor, 8)
        categoryLabel.pinLeft(to: self, sideMargin)
    }
    
    private func setDecriptionLabel(description: String?) {
        descriptionLabel.text = description ?? ""
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = Constants.mainTextColor
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.pinTop(to: categoryLabel.bottomAnchor, 10)
        descriptionLabel.pinLeft(to: self, sideMargin)
        descriptionLabel.pinRight(to: self, sideMargin)
    }
    
    private func getAttributedStringForReturn(returnWay: ItemReturn) -> NSAttributedString {
        let title: NSMutableAttributedString = NSMutableAttributedString(
            string: "Where to get back:\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)]
        )
        
        let returnString: String = returnWay.getDescriprion()
        
        let attributedReturnString: NSAttributedString = NSAttributedString(
            string: returnString,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        title.append(attributedReturnString)
        return title
    }
    
    private func setReturnLabel(returnWay: ItemReturn) {
        returnLabel.lineBreakMode = .byWordWrapping
        returnLabel.numberOfLines = 0
        returnLabel.attributedText = getAttributedStringForReturn(returnWay: returnWay)
        returnLabel.textColor = Constants.mainTextColor
        returnLabel.pinTop(to: descriptionLabel.bottomAnchor, 20)
        returnLabel.pinLeft(to: self, sideMargin)
        returnLabel.pinRight(to: self, sideMargin)
    }
    
    private func getAttributedStringForDate(date: Date) -> NSAttributedString {
        let title: NSMutableAttributedString = NSMutableAttributedString(
            string: "Post was created at:\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)]
        )
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        let stringDate = dateFormatter.string(from: date)
        
        let attributedReturnString: NSAttributedString = NSAttributedString(
            string: stringDate,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        title.append(attributedReturnString)
        return title
    }
    
    private func setDateLabel(date: Date) {
        dateLabel.numberOfLines = 2
        dateLabel.attributedText = getAttributedStringForDate(date: date)
        dateLabel.textColor = Constants.mainTextColor
        dateLabel.pinTop(to: returnLabel.bottomAnchor, 15)
        dateLabel.pinLeft(to: self, sideMargin)
        dateLabel.pinRight(to: self, sideMargin)
    }
}
