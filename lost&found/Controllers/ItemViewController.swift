import Foundation
import UIKit

class ItemViewController: UIViewController {
    let item: ItemModel
    var itemView: ItemView {
        return self.view as! ItemView
    }
    
    init(item: ItemModel) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ItemView()
    }
    
    override func viewDidLoad() {
        itemView.setLayout(for: item)
    }
    
    
}
