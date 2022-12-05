//
//  Data Structure.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 14/11/2022.
//

import Foundation
import CoreMotion
import CoreLocation
import UIKit

enum alerts : String {
    case acceleration1
    case acceleration2
    case freinage1
    case freinage2
    case gauche1
    case gauche2
    case droite1
    case droite2
    case manip
    case newaxe_acc
    case newaxe_fre
    
    var description : String {
        return self.rawValue
    }
}

enum sign {
    case positif
    case negatif
}

extension sign{
    func inverse() -> sign {
        return self == .positif ? .negatif : .positif
    }
}

struct coord{
    var x : Double
    var y : Double
    var z : Double
    
    
    var const : Double? = nil
    
    var ms_x : Double {
        return (self.x)*9.80665
    }
    
    var ms_y : Double {
        return (self.y)*9.80665
    }
    
    var ms_z : Double {
        return (self.z)*9.80665
    }
    
    var signX : sign {
        return x < 0 ? .negatif : .positif
    }
    
    var norme : Double {
        return sqrt(pow(x,2)+pow(y,2)+pow(z,2))
    }
    
    var ms_norme : Double {
        return sqrt(pow(x,2)+pow(y, 2)+pow(z,2))
    }
}

enum CarBehaviour {
    case acceleration
    case breaking
    case none
}

enum CarLateralBehaviour {
    case left
    case right
}

extension CarBehaviour {
    func inverse() -> CarBehaviour{
        return self == .acceleration ? .breaking : .acceleration
    }
}

struct userAccelerationData {
    let userAcceleration : CMAcceleration
    let gravity : CMAcceleration
    let timstamp : TimeInterval
    
    var coordUserAcceleration : coord {
        return coord(x: userAcceleration.x, y: userAcceleration.y, z: userAcceleration.z)
    }
    
    var gx : Double { return gravity.x }
    var gy : Double { return gravity.y }
    var gz : Double { return gravity.z }
    
}

struct userLocationData {
    let location : CLLocation
    let speed : CLLocationSpeed
    let speedAccuracy : CLLocationSpeedAccuracy
    let timstamp : TimeInterval
}

struct log {
    var logData : String
    var date : Int
    
    var dictionary: [String: Any] {
        return ["log": logData, "date": date]
    }
    

}

extension Double {
    var earth_g : Double {
        return 9.81
    }
}

struct QueueLog<T>{
    private var elements: [T] = []
    
    mutating func enqueue(_ value: T, completion : @escaping ()->()) {
        elements.append(value)
        completion()
//        textView.text = getFormText()
    }
    
    public var description: [T] {
        return elements
    }
    
    mutating func getFormText() -> String {
        var text = String()
        for element in elements {
            text = text + (element as! String) + "\n"
        }
        return text
    }
    
    mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
          return nil
        }
        return elements.removeFirst()
      }

      var head: T? {
        return elements.first
      }

      var tail: T? {
        return elements.last
      }
}


struct QueueAccelerometer<T>{
    private var elements: [T] = []
    public var gravity : coord?
    public var gravityStack : [coord] = []
    
    mutating func enqueue(_ value: T) {
        elements.append(value)
        if elements.count > (T.self == userAccelerationData.self ? 50 : 100) {
            elements.removeFirst()
        }
    }
    
    mutating func addGravity(_ value: coord){
        if gravityStack.count == 25 {
            gravityStack.removeFirst()
            gravityStack.append(value)
        }else{
            gravityStack.append(value)
        }
    }

    
    public var description: [T] {
        // 3
        return elements
    }
    
    public var isEmpty : Bool {
        return elements.isEmpty
    }
    
    public var size : Int {
        return elements.count
    }
    
    public var lastSpeed : Double {
        return ((elements.last as! userLocationData).speed*3.600)
    }
    
    public var fiveLastSpeedCalc : [Double] {
        var fiveLastSpeed : [Double] = []
        let fiveLastLocations = Array(elements.suffix(6))
        for (index,location) in fiveLastLocations.enumerated() {
            if index == 5 { break }
            let fromLoc = location as! userLocationData
            let toLoc = fiveLastLocations[index+1] as! userLocationData
            print("HER",index, fiveLastLocations.count,fiveLastLocations[index+1])
            let speed = ACMathMethod.shared.calculSpeed(coord1: fromLoc.location, coord2: toLoc.location, timestmp1: fromLoc.timstamp, timestmp2: toLoc.timstamp)
            fiveLastSpeed.append(abs(speed))
//            fiveLastSpeed.append(((location as! userLocationData).speed.binade*3600)/1000)
        }
        return fiveLastSpeed
    }
    
    public var variance : Double {
        
        let triplets = Array(elements.suffix(10)) as! [userAccelerationData]
        
        var currentVarianceX:Double = 0
        var currentVarianceY:Double = 0
        var currentVarianceZ:Double = 0
        
        for i in 0...triplets.count - 2 {
            currentVarianceX += abs(triplets[i].gx - triplets[i + 1].gx)
            currentVarianceY += abs(triplets[i].gy - triplets[i + 1].gy)
            currentVarianceZ += abs(triplets[i].gz - triplets[i + 1].gz)
        }
        return currentVarianceX + currentVarianceY + currentVarianceZ
    }
    
    public var fiveLastSpeedLoc : [Double] {
        var fiveLastSpeed : [Double] = []
        let fiveLastLocations = Array(elements.suffix(6))
        
        for location in fiveLastLocations {
            let loc = location as! userLocationData
            if loc.speedAccuracy < 0 {
                fiveLastSpeed.append(-1)
                continue
            }
            fiveLastSpeed.append(abs(loc.speed))
        }
        return fiveLastSpeed
    }
    
    public var fiveLastCoord : [CLLocationCoordinate2D] {
        var fiveLastSpeed : [CLLocationCoordinate2D] = []
        let fiveLastLocations = elements.suffix(5)
        for location in fiveLastLocations {
            fiveLastSpeed.append(((location as! userLocationData).location.coordinate))
        }
        return fiveLastSpeed
    }
    
    public var lastAverageFiveSecond : coord {
        let lastAccelerometers = elements.suffix(50)
        var averageForce = coord(x: 0, y: 0, z: 0)
        
        
        for accelerometer in lastAccelerometers {
            averageForce.x += (accelerometer as! userAccelerationData).userAcceleration.x
            averageForce.y += (accelerometer as! userAccelerationData).userAcceleration.y
            averageForce.z += (accelerometer as! userAccelerationData).userAcceleration.z
        }
        
        averageForce.x = averageForce.x/50
        averageForce.y /= 50
        averageForce.z /= 50
        
        return averageForce
    }
    
    public var lastAverageTwoSecond : coord {
        let lastAccelerometers = elements.suffix(10)
        
        var averageForce = coord(x: 0, y: 0, z: 0)
        
        
        for accelerometer in lastAccelerometers {
            averageForce.x += (accelerometer as! userAccelerationData).userAcceleration.x
            averageForce.y += (accelerometer as! userAccelerationData).userAcceleration.y
            averageForce.z += (accelerometer as! userAccelerationData).userAcceleration.z
        }
        
        averageForce.x = averageForce.x/10
        averageForce.y = averageForce.y/10
        averageForce.z = averageForce.z/10
        
        return averageForce
    }
    
    public var lastAverageSecond : coord {
        let lastAccelerometers = elements.suffix(5)
        
        var averageForce = coord(x: 0, y: 0, z: 0)
        
        
        for accelerometer in lastAccelerometers {
            averageForce.x += (accelerometer as! userAccelerationData).userAcceleration.x
            averageForce.y += (accelerometer as! userAccelerationData).userAcceleration.y
            averageForce.z += (accelerometer as! userAccelerationData).userAcceleration.z
        }
        
        averageForce.x = averageForce.x/5
        averageForce.y = averageForce.y/5
        averageForce.z = averageForce.z/5
        
        return averageForce
    }
    
    
    
    mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
          return nil
        }
        return elements.removeFirst()
      }

      var head: T? {
        return elements.first
      }

      var tail: T? {
        return elements.last
      }
}
