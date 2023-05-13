import Foundation
import UIKit

class AddButton: UIButton {
    let size: Int = 56
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        setWidth(size)
        setHeight(size)
        backgroundColor = Constants.mainBlueColor
        layer.cornerRadius = CGFloat(size) / 2
        let iconImage = UIImage(named: "PlusIcon")
        setImage(iconImage, for: .normal)
        tintColor = .white
    }
    
    func setupExternalLayout() {
        guard let superview = superview else { return }
        pinCenterX(to: superview)
        pinBottom(to: superview.topAnchor, -size / 2)
    }
}
