//
//  speedometerMethod.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 16/11/2022.
//

import Foundation
import CoreLocation

class locationDelegate: NSObject, CLLocationManagerDelegate {
    var last:CLLocation?
    override init() {
      super.init()
    }
    
    func locationManager(_ manager: CLLocationManager,
                 didUpdateLocations locations: [CLLocation]) {
        
    }
}


