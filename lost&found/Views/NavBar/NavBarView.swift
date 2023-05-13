import Foundation
import UIKit

public class NavigationBarView: UIView {
    private let buttons: [UIButton] = [NavBarIcon(.map), NavBarIcon(.account)]
    private let buttonsStack: UIStackView = UIStackView()
    private let addPostButton: AddButton = AddButton()
    
    weak var delegate: NavBarDelegate?
    
    init(controller: NavBarDelegate?) {
        super.init(frame: .zero)
        delegate = controller
        
        setupLayout()
        setButtonsStack()
        setAddPostButton()
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButtonsStack() {
        for button in buttons {
            buttonsStack.addArrangedSubview(button)
        }
        buttonsStack.axis = .horizontal
        buttonsStack.distribution = .equalSpacing
        buttonsStack.alignment = .center
        addSubview(buttonsStack)
        buttonsStack.pin(to: self, [.left: 33, .right: 33, .top: 0, .bottom: 0])
        
        buttons[0].addTarget(
            delegate,
            action: #selector(NavBarDelegate.mapIconButtonGetPressed),
            for: .touchUpInside
        )
        buttons[1].addTarget(
            delegate,
            action: #selector(NavBarDelegate.userAccountButtonGetPressed),
            for: .touchUpInside
        )
    }
    
    private func setAddPostButton() {
        addSubview(addPostButton)
        addPostButton.setupExternalLayout()
        addPostButton.addTarget(
            delegate,
            action: #selector(NavBarDelegate.addPostButtonGetPressed),
            for: .touchUpInside
        )
    }
    
    private func setupLayout() {
        backgroundColor = .white
        layer.cornerRadius = 20
        setHeight(66)
        setWidth(260)
    }
    
    func setupExternalLayout() {
        guard let superview = superview else { return }
        pinBottom(to: superview, 60)
        pinCenterX(to: superview)
    }
}
