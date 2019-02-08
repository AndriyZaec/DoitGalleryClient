//
//  LocationHelper.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationHelper {
    
    private var location: CLLocation
    
    init(with latitude: Double, longitude: Double) {
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func geocode(_ completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
}
