//
//  view.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 14/11/2022.
//

import UIKit
import CoreMotion

class homeView: UIView {
    
    let AccView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        return view
    }()
    
    let brutAccLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let accUserLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let gravityUserLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let axesLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let speedUserLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let logView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let logLabel : UILabel = {
        let label = UILabel()
        label.text = "LOG"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .blue
        return textView
    }()
    
    let viewProgress : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        return view
    }()
    
    let accelerationLabel : UILabel = {
        let label = UILabel()
        label.text = "Acceleration"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let breakingLabel : UILabel = {
        let label = UILabel()
        label.text = "Freinage"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressBarAccelerationPos : UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = .white
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = .white
        progressBar.tintColor = .systemGreen
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        progressBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

        return progressBar
    }()
    
    let separatorMiddleProgressAcc : UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let separatorMiddleProgressLat : UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let progressBarAccelerationNeg : UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = .white
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = .white
        progressBar.tintColor = .systemRed
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        progressBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        progressBar.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(Double.pi), 1.0, -1.0)
        return progressBar
    }()
    
    let turnLabelG : UILabel = {
        let label = UILabel()
        label.text = "Gauche"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let turnLabelD : UILabel = {
        let label = UILabel()
        label.text = "Droite"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressBarLateralPos : UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = .white
        progressBar.tintColor = .systemGreen
        progressBar.layer.cornerRadius = 10
        progressBar.trackTintColor = .white
        progressBar.clipsToBounds = true
        progressBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return progressBar

    }()
    
    let progressBarLateralNeg : UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = .white
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = .white
        progressBar.tintColor = .systemRed
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        progressBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        progressBar.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(Double.pi), 1.0, -1.0)

        return progressBar
    }()
    
    let startButton : UIButton = {
        let button = UIButton()
        button.setTitle("START", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let seuilAccTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Accel"
        textField.keyboardType = .numbersAndPunctuation
        textField.text = "20"
        textField.backgroundColor = .gray
        return textField
    }()
    
    let seuilFreTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Fre"
        textField.text = "15"
        textField.keyboardType = .numbersAndPunctuation
        textField.backgroundColor = .gray
        return textField
    }()
    
    //3 valeur et new point
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(AccView)
        addSubview(logView)
        addSubview(viewProgress)
        
        AccView.addSubview(speedUserLabel)
        AccView.addSubview(accUserLabel)
        AccView.addSubview(gravityUserLabel)
        AccView.addSubview(accelerationLabel)
        AccView.addSubview(axesLabel)
        AccView.addSubview(brutAccLabel)
        
//        logView.addSubview(logLabel)
        logView.addSubview(logTextView)
        logView.addSubview(seuilAccTextField)
        logView.addSubview(seuilFreTextField)
        
        viewProgress.addSubview(accelerationLabel)
        viewProgress.addSubview(breakingLabel)
        viewProgress.addSubview(progressBarAccelerationPos)
        viewProgress.addSubview(progressBarAccelerationNeg)
        viewProgress.addSubview(turnLabelG)
        viewProgress.addSubview(turnLabelD)
        viewProgress.addSubview(progressBarLateralPos)
        viewProgress.addSubview(progressBarLateralNeg)
        
        viewProgress.addSubview(separatorMiddleProgressAcc)
        viewProgress.addSubview(separatorMiddleProgressLat)

        setAccCons()
        setConsLog()
        setProgCons()
    }
    
    func setTextFieldDelegate(delegate : ViewController){
        seuilAccTextField.delegate = delegate
        seuilFreTextField.delegate = delegate
    }
    
    func setAccCons(){
        NSLayoutConstraint.activate([
            
         
            
            AccView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            AccView.leadingAnchor.constraint(equalTo: leadingAnchor),
            AccView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            brutAccLabel.topAnchor.constraint(equalTo: AccView.topAnchor,constant: 10),
            brutAccLabel.centerXAnchor.constraint(equalTo: AccView.centerXAnchor),
            
            accUserLabel.topAnchor.constraint(equalTo: brutAccLabel.bottomAnchor,constant: 10),
            accUserLabel.centerXAnchor.constraint(equalTo: AccView.centerXAnchor),
            axesLabel.topAnchor.constraint(equalTo: accUserLabel.bottomAnchor, constant: 30),
            axesLabel.centerXAnchor.constraint(equalTo: AccView.centerXAnchor),
            gravityUserLabel.topAnchor.constraint(equalTo: axesLabel.bottomAnchor,constant: 10),
            gravityUserLabel.centerXAnchor.constraint(equalTo: AccView.centerXAnchor),
            
            speedUserLabel.bottomAnchor.constraint(equalTo: AccView.bottomAnchor,constant: -10),
            speedUserLabel.topAnchor.constraint(equalTo: gravityUserLabel.bottomAnchor,constant: 15),
            speedUserLabel.centerXAnchor.constraint(equalTo: AccView.centerXAnchor)
        ])
    }
    
    func setConsLog(){
        NSLayoutConstraint.activate([
            logView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            logView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            logView.topAnchor.constraint(equalTo: AccView.bottomAnchor,constant: 10),
            
            seuilAccTextField.leadingAnchor.constraint(equalTo: logView.leadingAnchor),
            seuilAccTextField.trailingAnchor.constraint(equalTo: logView.centerXAnchor),
            seuilAccTextField.topAnchor.constraint(equalTo: logView.topAnchor),
            seuilAccTextField.heightAnchor.constraint(equalToConstant: 40),
            seuilFreTextField.leadingAnchor.constraint(equalTo: seuilAccTextField.trailingAnchor),
            seuilFreTextField.trailingAnchor.constraint(equalTo: logView.trailingAnchor),
            seuilFreTextField.topAnchor.constraint(equalTo: seuilAccTextField.topAnchor),
            seuilFreTextField.bottomAnchor.constraint(equalTo: seuilAccTextField.bottomAnchor),
//            
//            logLabel.topAnchor.constraint(equalTo: logView.topAnchor,constant: 10),
//            logLabel.centerXAnchor.constraint(equalTo: logView.centerXAnchor),
          
            logTextView.topAnchor.constraint(equalTo: seuilAccTextField.bottomAnchor),
            logTextView.leadingAnchor.constraint(equalTo: logView.leadingAnchor),
            logTextView.trailingAnchor.constraint(equalTo: logView.trailingAnchor),
            logTextView.bottomAnchor.constraint(equalTo: logView.bottomAnchor),
            logView.bottomAnchor.constraint(equalTo: viewProgress.topAnchor)
        ])
    }
    
    func updateProgressBar(behaviourFB : CarBehaviour , normeFB : Double , behaviourLR : CarLateralBehaviour, normeLR : Double ){
        let maxAcc = 2.25
        let maxFre = 2.75
        let maxLat = 1.75
        let accelerationVarFB = normeFB
        let accelerationVarLR = normeLR
        
        let maxToUseFB = behaviourFB == .acceleration ? maxAcc : maxFre
        
        let progressFB : Float = Float(accelerationVarFB) / Float(maxToUseFB)
        let progressLR : Float = Float(accelerationVarLR) / Float(maxLat)
        
        

        if behaviourFB == .acceleration {
            if (progressBarAccelerationPos.progress > 0){
                UIView.animate(withDuration: 0.5) {
                    self.progressBarAccelerationPos.setProgress(0, animated: true)
                }completion: { _ in
                    self.progressBarAccelerationNeg.setProgress(progressFB, animated: true)
                }
            }else{
                UIView.animate(withDuration: 0.5) {
                    self.progressBarAccelerationNeg.setProgress(progressFB, animated: true)
                }
            }
        }else{
            if (progressBarAccelerationNeg.progress > 0){
                UIView.animate(withDuration: 0.5) {
                    self.progressBarAccelerationNeg.setProgress(0, animated: true)
                }completion: { _ in
                    self.progressBarAccelerationPos.setProgress(progressFB, animated: true)
                }
            }else{
                UIView.animate(withDuration: 0.5) {
                    self.progressBarAccelerationPos.setProgress(progressFB, animated: true)
                }
            }
        }
        
        if behaviourLR == .left {
//            progressBarLateralNeg.trackTintColor = .red
//            progressBarLateralPos.trackTintColor = .white
            progressBarLateralPos.setProgress(0, animated: true)
            progressBarLateralNeg.setProgress(progressLR, animated: true)
        }else{
            progressBarLateralNeg.setProgress(0, animated: true)
            progressBarLateralPos.setProgress(progressLR, animated: true)
        }
        return
        
    }
    
    func setProgCons(){
        NSLayoutConstraint.activate([
            
            viewProgress.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            viewProgress.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewProgress.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            accelerationLabel.topAnchor.constraint(equalTo: viewProgress.topAnchor,constant: 10),
            accelerationLabel.leadingAnchor.constraint(equalTo: viewProgress.leadingAnchor,constant: 10),
            breakingLabel.centerYAnchor.constraint(equalTo: accelerationLabel.centerYAnchor),
            breakingLabel.trailingAnchor.constraint(equalTo: viewProgress.trailingAnchor,constant: -10),
            progressBarAccelerationNeg.topAnchor.constraint(equalTo: accelerationLabel.bottomAnchor,constant: 10),
            progressBarAccelerationNeg.leadingAnchor.constraint(equalTo: viewProgress.leadingAnchor,constant: 10),
            progressBarAccelerationNeg.trailingAnchor.constraint(equalTo: viewProgress.centerXAnchor),
            
            progressBarAccelerationPos.leadingAnchor.constraint(equalTo: progressBarAccelerationNeg.trailingAnchor),
            progressBarAccelerationPos.centerYAnchor.constraint(equalTo: progressBarAccelerationNeg.centerYAnchor),
            progressBarAccelerationPos.trailingAnchor.constraint(equalTo: viewProgress.trailingAnchor,constant: -10),
            
            
            turnLabelG.leadingAnchor.constraint(equalTo: accelerationLabel.leadingAnchor),
            turnLabelG.topAnchor.constraint(equalTo: progressBarAccelerationNeg.bottomAnchor,constant: 10),
            
            turnLabelD.trailingAnchor.constraint(equalTo: viewProgress.trailingAnchor,constant: -10),
            turnLabelD.centerYAnchor.constraint(equalTo: turnLabelG.centerYAnchor),
            
            progressBarLateralNeg.leadingAnchor.constraint(equalTo: progressBarAccelerationNeg.leadingAnchor),
            progressBarLateralNeg.trailingAnchor.constraint(equalTo: viewProgress.centerXAnchor),
            progressBarLateralNeg.topAnchor.constraint(equalTo: turnLabelG.bottomAnchor),
            progressBarLateralNeg.bottomAnchor.constraint(equalTo: viewProgress.bottomAnchor,constant: -50),
            progressBarLateralPos.leadingAnchor.constraint(equalTo: progressBarLateralNeg.trailingAnchor),
            progressBarLateralPos.centerYAnchor.constraint(equalTo: progressBarLateralNeg.centerYAnchor),
            progressBarLateralPos.trailingAnchor.constraint(equalTo: progressBarAccelerationPos.trailingAnchor),
            
            
            
            progressBarLateralNeg.heightAnchor.constraint(equalToConstant: 20),
            progressBarAccelerationNeg.heightAnchor.constraint(equalToConstant: 20),
            progressBarAccelerationPos.heightAnchor.constraint(equalToConstant: 20),
            progressBarLateralPos.heightAnchor.constraint(equalToConstant: 20),
            
            separatorMiddleProgressAcc.centerXAnchor.constraint(equalTo: viewProgress.centerXAnchor),
            separatorMiddleProgressAcc.centerYAnchor.constraint(equalTo: progressBarAccelerationPos.centerYAnchor),
            separatorMiddleProgressAcc.heightAnchor.constraint(equalTo:progressBarAccelerationPos.heightAnchor),
            separatorMiddleProgressAcc.widthAnchor.constraint(equalToConstant: 3),
            
            separatorMiddleProgressLat.centerXAnchor.constraint(equalTo: viewProgress.centerXAnchor),
            separatorMiddleProgressLat.centerYAnchor.constraint(equalTo: progressBarLateralNeg.centerYAnchor),
            separatorMiddleProgressLat.heightAnchor.constraint(equalTo:progressBarAccelerationPos.heightAnchor),
            separatorMiddleProgressLat.widthAnchor.constraint(equalToConstant: 3)
            
        ])
    }
    
    func setLabelText(motion : CMDeviceMotion,acceleration : CMAcceleration){
        let x = motion.userAcceleration.ms_x
        let y = motion.userAcceleration.ms_y
        let z = motion.userAcceleration.ms_z
        
        let bx = acceleration.ms_x
        let by = acceleration.ms_y
        let bz = acceleration.ms_z
        
        self.brutAccLabel.text = (String(format: "ACCELERATION BRUT \n x : %.2f | y : %.2f | z : %.2f", bx, by, bz))
        self.accUserLabel.text = (String(format: "ACCELERATION USER \n x : %.2f | y : %.2f | z : %.2f", x, y, z))
        self.gravityUserLabel.text = (String(format: " GRAVITY \n x : %.2f | y : %.2f | z : %.2f", motion.gravity.ms_x, motion.gravity.ms_y, motion.gravity.ms_z))
    }
    
//    func setMaxGravity(maxGCoord : coord){
//        axesLabel.text = (String(format:"MAXIMUM USER ACCELERATION : \(maxGCoord.norme)\nx: %.2f | y : %.2f | z : %.2f", maxGCoord.x,maxGCoord.y,maxGCoord.z))
//    }
    
    func setAxes(axeFB : coord , axeLR : coord, behaviour : CarBehaviour){
        let strAxeFB = (String(format: " GRAVITY \n x : %.2f | y : %.2f | z : %.2f", axeFB.x, axeFB.y, axeFB.z))
        let strAxeLR = (String(format: " GRAVITY \n x : %.2f | y : %.2f | z : %.2f", axeLR.x, axeLR.y, axeLR.z))
        
        let isLeft = behaviour == .acceleration
        let isBack = behaviour == .acceleration
        axesLabel.text = "VECTOR DIRECTION\nFB \(isBack ? "Back" : "Front") => \(strAxeFB)\nLR \(isLeft ? "LEFT" : "RIGHT") => \(strAxeLR)"
    }
    
    func updateSpeed(speed : Double){
        
        speedUserLabel.text = "VITESSE \n\(speed <= 0 ? 0 : speed) km.h^-1"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
