//
//  ViewController.swift
//  lost&found
//
//  Created by Polina Kopyrina on 14.03.2023.
//

import UIKit

class ViewController: UIViewController {
    //let views: [UIView] = [ MainMapView(), PersonPageView(), ItemView(), RegistrateView(), LoginView(), CreatePostView() ]
    
    let mapController: UIViewController = MapController()
    
    //private var activeUser: User
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        placeMapController()
    }

    func placeMapController() {
        mapController.modalPresentationStyle = .fullScreen
        present(mapController, animated: true, completion: nil)
    }
}

