import Foundation
import UIKit

final public class NavBarIcon: UIButton {
    
    init(_ icon: NavLink) {
        super.init(frame: .zero)
        setupLayout(icon: icon)
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(icon: NavLink) {
        let size: Int = 28
        setWidth(size)
        setHeight(size)
        let iconImage = UIImage(named: icon.rawValue)
        setImage(iconImage, for: .normal)
    }
}
