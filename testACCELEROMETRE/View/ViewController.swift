//
//  ViewController.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 09/11/2022.
//

import UIKit
import CoreMotion
import CoreLocation
import Alamofire

import AVFoundation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    /* MANAGER */
    
    var gravityBehavior = UIGravityBehavior()
    let locationManager = CLLocationManager()
    let motionManager : CMMotionManager = {
        let manager = CMMotionManager()
        manager.deviceMotionUpdateInterval = 0.2
        return manager
    }()
    var logStack : [log] = []
    
    /* VUE */
    
    lazy var homeView : homeView = {
        let view = testACCELEROMETRE.homeView(frame: view.bounds)
        view.setTextFieldDelegate(delegate: self)
        return view
    }()
    
    /* DATA */
    
    var queueAccelerometer = QueueAccelerometer<userAccelerationData>()
    var queueLocation = QueueAccelerometer<userLocationData>()
    lazy var queueLog = QueueLog<String>()
    
    var last:CLLocation?
    
    
    /* VAR */
    var axeFB : coord?
    var axeLR : coord?
    
    var firstBehaviourFB : CarBehaviour?
    var firstBehaviourLR : CarBehaviour?
    
    var soundPlayer = SoundPlayer()
    
    var maxAcceleration : coord = coord(x: 0, y: 0, z: 0)
    
    var lastManipulationAlertTimestamp : TimeInterval?
    var lastAlertAccFreTimestamp : TimeInterval?
    var lastLocationUpdate : TimeInterval?
    var isManipulating : Bool = false
    
    var seuilFreinage : Int = 20
    var seuilAcceleration : Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        startMotionUpdate()
        soundPlayer.player?.delegate = soundPlayer

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.view.addSubview(homeView)
        UIApplication.shared.isIdleTimerDisabled = true
        
        hideKeyboardWhenTappedAround()

    }
    

    
    func checkIfAccelerationOrBraking() -> CarBehaviour{

        if (queueLocation.size < 6) { return .none }
        let fiveLastSpeed = queueLocation.fiveLastSpeedLoc
        if fiveLastSpeed.contains(-1) { return .none }
        if (fiveLastSpeed[0] < 5) { return .none }

        if fiveLastSpeed[4] - fiveLastSpeed[2] >= CGFloat(seuilAcceleration) { // 1
            return .acceleration
        }else if (fiveLastSpeed[0] > 20) && (fiveLastSpeed[2] - fiveLastSpeed[4] < CGFloat(seuilFreinage)){
            return .breaking
        }else{
            return .none
        }
    }
    
    
    func isRectiligne() -> Bool{
        if (queueLocation.size < 6) {return false}
        let fiveLastCoord = queueLocation.fiveLastCoord
        let c1 = fiveLastCoord[0]
        let c2 = fiveLastCoord[2]
        let c3 = fiveLastCoord[4]

        var angle = ACMathMethod.shared.getAngleLatLong(lat1: c1.latitude , lng1: c1.longitude, lat2: c2.latitude, lng2: c2.longitude, lat3: c3.latitude, lng3: c3.longitude)
        angle = 180 - abs(angle)
        return (angle > 165 && angle < 195)
    }

    
    func processLocation(_ current:CLLocation) -> Double{
        guard last != nil else {
            last = current
            return -1
        }
        var speed = current.speed
        
        if (speed > 0) {
            self.homeView.updateSpeed(speed: speed * 3.6)
        } else {
            speed = last!.distance(from: current) / (current.timestamp.timeIntervalSince(last!.timestamp))
            self.homeView.updateSpeed(speed: speed * 3.6)
        }
        last = current
        return speed * 3.6
    }
    
    func addLog(logData : String){
        let dateSTR = Date().getHMS().descriptionHMS()
        let log = log(logData: dateSTR + " - " + logData, date: Int(Date().timeIntervalSince1970))
        AppRequest.shared.requestPostLog(logs : [log])
            
        homeView.logTextView.text = homeView.logTextView.text + "\n\(Date().getHMS().descriptionHMS()) =>\(logData)\n"
        let range = NSMakeRange(homeView.logTextView.text.count - 1, 0)
        homeView.logTextView.scrollRangeToVisible(range)
    }

}

//MARK: TEXTFIELD

extension ViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == homeView.seuilFreTextField{
            seuilFreinage = Int(textField.text ?? "20") ?? 20
        }
        
        if textField == homeView.seuilAccTextField{
            seuilFreinage = Int(textField.text ?? "25") ?? 25
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isNumber{
            return true
        }
        return false

    }
}

//MARK: LOCATION
extension ViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        
        let speed = processLocation(locations.first!)
        let location = userLocationData(location: locations.first!, speed: speed < 0 ? 0 : speed, speedAccuracy: locations.first!.speedAccuracy ,timstamp: manager.location!.timestamp.timeIntervalSince1970)
        queueLocation.enqueue(location)
        
        
        
        if isManipulating {
            return
        }
        
        if lastLocationUpdate == nil {
            lastLocationUpdate = Date().timeIntervalSince1970
        }else{
            let intervalSinceLastUpdate = Int(Date().timeIntervalSince1970 - lastLocationUpdate!)
            if intervalSinceLastUpdate < 60 {
                return
            }
        }
        
        let behaviour = checkIfAccelerationOrBraking()
        if behaviour == .none {
            return
        }
        if !isRectiligne() {
            return
        }
        
        let lastAverageAccelerometer : coord = queueAccelerometer.lastAverageSecond
        
        addLog(logData: "Location manager - behavior detected \(behaviour) & trajectory rectiline")

        guard let gravityVector = queueAccelerometer.gravity else { return }
        axeFB = ACMathMethod.shared.projeteAcceleration2D(poids: gravityVector, acc: lastAverageAccelerometer)
        firstBehaviourFB = behaviour
        addLog(logData: "Location manager - set axeFB => \(String(describing: axeFB!))")
        axeLR = ACMathMethod.shared.getLeftRightAxes(frontBackaxe: axeFB!, gravityAxe: gravityVector)
        firstBehaviourLR = behaviour
        addLog(logData: "Location manager - set axeLR => \(String(describing: axeLR!))")
        
        guard let axeFB = axeFB , let axeLR = axeLR else { return }
        
        addLog(logData: "Axe updated on \(behaviour) : FB = \(axeFB) | \(axeLR)")
        homeView.setAxes(axeFB: axeFB, axeLR: axeLR, behaviour: behaviour)
        soundPlayer.playAlertNewAxe(behaviour: behaviour)
        
    }
}





//MARK: ACCELEROMETER
extension ViewController {
    func startMotionUpdate(){
        motionManager.startAccelerometerUpdates()
        motionManager.startDeviceMotionUpdates(to: .main) { [self] (motion, error) in
            
            if let motion = motion {
                
                var cmAcc : CMAcceleration
                
                if queueAccelerometer.gravity != nil {
                    cmAcc = CMAcceleration(x: (motionManager.accelerometerData?.acceleration.x)! - queueAccelerometer.gravity!.x , y: (motionManager.accelerometerData?.acceleration.y)! - queueAccelerometer.gravity!.y, z: (motionManager.accelerometerData?.acceleration.z)! - queueAccelerometer.gravity!.z)
                }else{
                    cmAcc = motion.userAcceleration
                }
                
                
                let dataAcceleration = userAccelerationData(userAcceleration: cmAcc, gravity: motion.gravity, timstamp: motion.timestamp)
                
                queueAccelerometer.enqueue(dataAcceleration)
                
                let g_vector = coord(x: motion.gravity.x, y: motion.gravity.y, z: motion.gravity.z)
                
                if queueAccelerometer.gravity == nil {
                    queueAccelerometer.gravity = g_vector
                }
                
                self.homeView.setLabelText(motion: motion, acceleration : motionManager.accelerometerData!.acceleration)
                
                queueAccelerometer.addGravity(g_vector)
                
                let newAcceleration = dataAcceleration.coordUserAcceleration.norme
                if newAcceleration > maxAcceleration.norme {
                    maxAcceleration = dataAcceleration.coordUserAcceleration
                }
                
                if queueAccelerometer.size < 20 { return }
                
                if checkIfAlertManipulation(){
                    isManipulating = true
                    homeView.updateProgressBar(behaviourFB: .acceleration, normeFB: 0, behaviourLR: .left, normeLR: 0)
                    axeLR = nil
                    axeFB = nil
                    return
                }else{
                    isManipulating = false
                }
                
                guard let axeLR = axeLR , let axeFB = axeFB else { return }
                
                let lastAverageAccelerometer : coord = queueAccelerometer.lastAverageSecond
                let coordOnAxeFB = ACMathMethod.shared.projeteDroiteAcceleration(droite: axeFB, point: lastAverageAccelerometer)
                let coordOnAxeLR = ACMathMethod.shared.projeteDroiteAcceleration(droite: axeLR, point: lastAverageAccelerometer)
                
                
                var behaviourAnalyseFB : CarBehaviour
                var behaviourAnalyseLR : CarLateralBehaviour
                
                let normeFB = coordOnAxeFB.ms_norme
                
                if coordOnAxeFB.signX == axeFB.signX {
                    behaviourAnalyseFB = firstBehaviourFB == .acceleration ? .acceleration : .breaking
                }else{
                    behaviourAnalyseFB = firstBehaviourFB == .acceleration ? .breaking : .acceleration
                }
                
                let normeLR = coordOnAxeLR.ms_norme
                
                if coordOnAxeLR.signX == axeLR.signX {
                    behaviourAnalyseLR = firstBehaviourLR == .acceleration ? .left : .right
                }else{
                    behaviourAnalyseLR = firstBehaviourLR == .acceleration ? .right : .left
                }
                
                
                
                let dataToLog = "\(behaviourAnalyseFB) => \(normeFB) | \(behaviourAnalyseLR) => \(normeLR)"
                addLog(logData: dataToLog)

                
                
                checkIfIsAlert(behaviourFB: behaviourAnalyseFB, normeFB: abs(normeFB), behaviourLR: behaviourAnalyseLR, normeLR: abs(normeLR))
                homeView.updateProgressBar(behaviourFB: behaviourAnalyseFB, normeFB: abs(normeFB), behaviourLR: behaviourAnalyseLR, normeLR: abs(normeLR))
                
            }
        }
        
    }
    
    func checkIfAlertManipulation()  -> Bool {
        
        if lastManipulationAlertTimestamp == nil {
            lastManipulationAlertTimestamp = Date().timeIntervalSince1970
        }else{
            let diff : Int = Int(Date().timeIntervalSince1970 - lastManipulationAlertTimestamp!)
            if diff < 15 {
                return true
            }
        }
        
        let variance = queueAccelerometer.variance
        if (variance > 2) {
            soundPlayer.playAlertManip()
            
            lastManipulationAlertTimestamp = Date().timeIntervalSince1970
            return true
        }
        
        return false
        
    }
    
    func checkIfAlertIsManipulationIsFinished() -> Bool? {
        guard let lastManipulationAlertTimestamp = lastManipulationAlertTimestamp else { return nil }
        
        let difference = Int(Date().timeIntervalSince1970 - lastManipulationAlertTimestamp)
        return difference > 60
        
    }
    
    func checkIfIsAlert(behaviourFB : CarBehaviour , normeFB : Double , behaviourLR : CarLateralBehaviour, normeLR : Double){
        
        var alertLR : alerts?
        var alertFB : alerts?
        //LATERAL
        
        addLog(logData: "Check IF ALERT -> FB = \(normeFB) | LR = \(normeLR)")
        if (normeLR > 1.25){
            alertLR = behaviourLR == .left ? .gauche1 : .droite1
            if normeLR > 1.5 {
                alertLR = behaviourLR == .left ? .gauche2 : .droite2
            }
        }
        
        if behaviourFB == .acceleration{
            if (normeFB > 1.5){
                alertFB = .acceleration1
                if (normeFB > 2.0 ){
                    alertFB = .acceleration2
                }
            }
        }else{
            if (normeFB > 2.0){
                alertFB = .freinage1
                if (normeFB > 2.5){
                    alertFB = .freinage2
                }
            }
        }
        
        soundPlayer.playAlert(alertFB: alertFB, alertLR: alertLR)
        
    }
}


//VECTEUR GRAVITE -> DEBUT -> FAIBLE VARIANCE ->

// CONVERTIR EN M.S^2
