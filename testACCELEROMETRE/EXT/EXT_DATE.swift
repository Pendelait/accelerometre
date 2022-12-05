//
//  EXT_DATE.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 16/11/2022.
//

import Foundation

extension Date{
    
    struct HMS{
        var hour : Int
        var minute : Int
        var seconde : Int
        
        func descriptionHMS() -> String  {
            return "\(hour):\(minute):\(seconde)"
        }
    }
    
    func getHMS() -> HMS{
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        let hms = HMS(hour: hour, minute: minutes, seconde: seconds)
        return hms
    }
    
}
