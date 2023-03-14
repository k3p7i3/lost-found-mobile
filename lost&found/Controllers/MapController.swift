//
//  MapController.swift
//  lost&found
//
//  Created by Polina Kopyrina on 14.03.2023.
//

import Foundation
import UIKit

class MapController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = MapView(controller: self)
    }
}
