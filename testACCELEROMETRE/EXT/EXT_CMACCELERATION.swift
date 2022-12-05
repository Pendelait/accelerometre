//
//  EXT_CMACCELERATION.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 30/11/2022.
//

import Foundation
import CoreMotion

extension CMAcceleration {
    var ms_x : Double { return (self.x)*9.80665 }
    
    var ms_y : Double { return (self.y)*9.80665 }
    
    var ms_z : Double { return (self.z)*9.80665 }
}
