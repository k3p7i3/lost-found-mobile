import Foundation
import UIKit
import MapKit

public class PickLocationMapView: MKMapView {
    let confirmButton: UIButton = UIButton()
    
    init(
        controller: LocationPickerController,
        initLocation: CLLocation?,
        frame: CGRect = UIScreen.main.bounds
    ) {
        super.init(frame: frame)
        if let location = initLocation {
            centerToLocation(location)
        } else {
            centerToLocation(Constants.baseLocation, regionRadius: 2000)
        }
        setConfirmButton(controller: controller)
    }

    @available(*, unavailable)
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfirmButton(controller: LocationPickerController) {
        addSubview(confirmButton)
        confirmButton.backgroundColor = Constants.mainBlueColor
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 10
        
        confirmButton.pinCenterX(to: self)
        confirmButton.setWidth(150)
        confirmButton.setHeight(40)
        confirmButton.pinBottom(to: self, 35)
        
        confirmButton.addTarget(
            controller,
            action: #selector(LocationPickerController.didEndPickLocation),
            for: .touchUpInside
        )
    }
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
}
