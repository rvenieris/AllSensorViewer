//
//  LocationManager.swift
//  AllSensorViewer
//
//  Created by Ricardo Venieris on 29/11/20.
//

import Foundation
import CoreLocation
import Combine

/**
 Don't forget to add a Key = NSLocationWhenInUseUsageDescription and a value with an explannations of location usage in ifo.plist
 */

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
      
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var status: CLAuthorizationStatus? {
        willSet { objectWillChange.send() }
    }
    
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
    }
    
    @Published var placemark: CLPlacemark? {
        willSet { objectWillChange.send() }
    }
    
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    private func geocode() {
      guard let location = self.location else { return }
      geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
        guard error == nil else {
            self.placemark = CLPlacemark()
            return
        }
        self.placemark = places?.first
      })
    }
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.geocode()
    }
}


extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}
