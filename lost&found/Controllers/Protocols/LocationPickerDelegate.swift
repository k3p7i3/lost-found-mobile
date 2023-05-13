import Foundation
import MapKit

@objc protocol LocationPickerDelegate {
    func showLocationPicker()
    func didPickLocation(coordinate: CLLocationCoordinate2D)
    func closeLocationPicker()
}
