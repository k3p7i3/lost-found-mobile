import Foundation
import UIKit

class CollectionCell: UICollectionViewCell {
    var value: String? // raw value of enum
    fileprivate let textLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel.textColor = Constants.mainBlueColor
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
        contentView.backgroundColor = .white
        contentView.layer.borderColor = Constants.mainBlueColor.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 15
        textLabel.pin(to: contentView, [.top: 0, .left: 0, .right: 0, .bottom: 0])
        textLabel.numberOfLines = 0
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
        value = nil
    }
    
    public func selectLayout() {
        contentView.backgroundColor = Constants.mainBlueColor
        textLabel.textColor = .white
    }
    
    public func deselectLayout() {
        textLabel.textColor = Constants.mainBlueColor
        contentView.backgroundColor = .white
    }
}

final class CategoryCell: CollectionCell {
    static let reuseIdentifier: String = "CategoryCell"
    public func configure(with category: ItemCategory) {
        value = category.rawValue
        textLabel.text = category.rawValue
    }
}

final class ReturnWayCell: CollectionCell {
    static let reuseIdentifier: String = "ReturnWayCell"
    public func configure(with returnWay: ItemReturn) {
        value = returnWay.rawValue
        textLabel.text = returnWay.getDescriprion()
    }
}
