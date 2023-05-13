import UIKit

class MainViewController: UIViewController {
    let mapViewController: MapViewController = MapViewController()
    let userViewController: UserViewController = UserViewController()
    let loginViewController: LoginViewController = LoginViewController()
    let registrationViewController: RegistrationViewController = RegistrationViewController()
    
    var currentController: UIViewController?
    
    let defaults = UserDefaults.standard
    var currentUserId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewController.delegate = self
        userViewController.delegate = self
        loginViewController.delegate = self
        registrationViewController.delegate = self
        
        currentUserId = defaults.integer(forKey: "UserId")
        if currentUserId == 0 {
            placeLoginViewController()
        } else {
            placeMapController()
        }
        
    }
    
    func dismissCurrentController() {
        if let controller = currentController {
            controller.dismiss(animated: true)
        }
    }

    func placeMapController() {
        dismissCurrentController()
        
        currentController = mapViewController
        mapViewController.modalPresentationStyle = .fullScreen
        present(mapViewController, animated: true, completion: nil)
    }
    
    func placeLoginViewController() {
        dismissCurrentController()
        
        currentController = loginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
    
    func placeUserViewController() {
        dismissCurrentController()
        
        currentController = userViewController
        if currentUserId != userViewController.user?.userId {
            userViewController.changeForUser(userId: currentUserId)
        }
        userViewController.modalPresentationStyle = .fullScreen
        present(userViewController, animated: true, completion: nil)
    }
    
    func placeRegistrationViewController() {
        dismissCurrentController()
        
        currentController = registrationViewController
        registrationViewController.modalPresentationStyle = .fullScreen
        present(registrationViewController, animated: true, completion: nil)
    }
    
    func setCurrentUserId(userId: Int?) {
        if let userId = userId {
            currentUserId = userId
            defaults.set(userId, forKey: "UserId")
        }
    }
    
}

