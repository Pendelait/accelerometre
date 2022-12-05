//
//  ACMathMethod.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 16/11/2022.
//

import Foundation
import CoreLocation

class ACMathMethod : NSObject {
    
    static var shared = ACMathMethod()
    
    func getAngleLatLong(lat1 : Double, lng1 : Double, lat2 : Double, lng2 : Double, lat3 : Double, lng3 : Double) -> Double{
        let degrees_to_radians = Double.pi/180.0
        
        let a = pow(lat2-lat1, 2) + pow(lng2-lng1, 2)
        let b = pow(lat2-lat3, 2) + pow(lng2-lng3, 2)
        let c = pow(lat3-lat1, 2) + pow(lng3-lng1, 2)
        
        if(a > 0.0 && b > 0.0){
            var tempVal = (a+b-c) / sqrt(4*a*b)
            if abs(tempVal) > 1.0{
                tempVal = tempVal == 0 ? 0 : tempVal/abs(tempVal)
            }
            let phi = acos(tempVal)
            let direction = (lat2-lat1)*(lng3-lng1) - (lng2-lng1)*(lat3-lat1)
            if direction < 0 {
                let phi = -phi
                return phi/degrees_to_radians + 180
            }else{
                return phi/degrees_to_radians - 180
            }
        }else{
                print("HERE")
                return 0
        }
    }
    
    func getAngleBetween3Point(lat1 : Double, lng1 : Double, lat2 : Double, lng2 : Double, lat3 : Double, lng3 : Double) -> Double{
        let d1 = getDistanceInMeters(lat1: lat1, lon1: lng1, lat2: lat2, lon2: lng2)
        let d2 = getDistanceInMeters(lat1: lat2, lon1: lng2, lat2: lat3, lon2: lng3)
        let d3 = getDistanceInMeters(lat1: lat1, lon1: lng1, lat2: lat3, lon2: lng3)
        
        print(d1,d2,d3)
        let inAcos = ( pow(d1,2) + pow(d2, 2) - pow(d3,2) ) / (2 * d1 * d2)
        
        return acos(inAcos)
    }
    
    func getDistanceInMeters(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        
        let coordinate0 = CLLocation(latitude: lat1, longitude: lon1)
        let coordinate1 = CLLocation(latitude: lat2, longitude: lon2)
        
        let distance = coordinate0.distance(from: coordinate1)
        return distance
    }
    
    func calculSpeed(coord1 : CLLocation , coord2 : CLLocation ,timestmp1 : Double , timestmp2 : Double) -> Double{
        let distance = getDistanceInMeters(lat1: coord1.coordinate.latitude, lon1: coord1.coordinate.longitude, lat2: coord2.coordinate.latitude, lon2: coord2.coordinate.longitude)

        let date1 = Date(timeIntervalSince1970: timestmp1)
        let date2 = Date(timeIntervalSince1970: timestmp2)
        let deltaTime = date1.timeIntervalSince(date2)
        
        var speed = distance/deltaTime // m.s-1
        speed = speed * 3.6
        
        return speed
    }
    
    
    
    func projeteAcceleration2D(poids : coord , acc : coord) -> coord{
        let numerateur = poids.x*acc.x + poids.y*acc.y + poids.z*acc.z
        let denominateur = pow(poids.x,2) + pow(poids.y,2) + pow(poids.z, 2)
        let k = (((-1*numerateur))/denominateur)
        
        
        let newX = poids.x*k + acc.x
        let newY = poids.y*k + acc.y
        let newZ = poids.z*k + acc.z
        
        print("RESULTAT => K = \(k) | x : \(newX) | y : \(newY) | z : \(newZ)")
        
        return coord(x: newX, y: newY, z: newZ, const: k)
        
    }
    
    func getLeftRightAxes(frontBackaxe : coord , gravityAxe : coord) -> coord{
        let newX = frontBackaxe.y*gravityAxe.z - frontBackaxe.z*gravityAxe.y
        let newY = frontBackaxe.z*gravityAxe.x - frontBackaxe.x*gravityAxe.z
        let newZ = frontBackaxe.x*gravityAxe.y - frontBackaxe.y*gravityAxe.x
        
        return coord(x: newX, y: newY, z: newZ)
    }
    
    func projeteDroiteAcceleration(droite : coord , point : coord) -> coord{
        let numerateur = droite.x*point.x + droite.y*point.y + droite.z*point.z
        let denominateur = pow(droite.x,2) + pow(droite.y,2) + pow(droite.z, 2)
        let t = (numerateur/denominateur)
        
        
        let newX = droite.x*t
        let newY = droite.y*t
        let newZ = droite.z*t
        
        print("RESULTAT => T = \(t) | x : \(newX) | y : \(newY) | z : \(newZ)")
        return coord(x: newX, y: newY, z: newZ)
    }
    
    
    
}
