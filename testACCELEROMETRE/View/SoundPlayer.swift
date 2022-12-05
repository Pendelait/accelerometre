//
//  SoundPlayer.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 25/11/2022.
//

import Foundation
import AVFoundation



class SoundPlayer : NSObject, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer?
    static var shared : SoundPlayer = SoundPlayer()
    var listToPlay : [alerts] = []

    
    
    func playAlert(alertFB : alerts? , alertLR : alerts?) {

        if alertFB != nil {
            listToPlay.append(alertFB!)
        }
        if alertLR != nil {
            listToPlay.append(alertLR!)
        }
        if listToPlay.isEmpty {
            return
        } else if !(isPlaying()){
            launchSong()
        }
    }
    
    func playAlertManip(){
      
        listToPlay.append(.manip)
        if !(isPlaying()){
            launchSong()
        }
    }
    
    func isPlaying() -> Bool {
        if let player = player {
            return player.isPlaying
        }else {
            return false
        }
    }
        
    
    func playAlertNewAxe(behaviour : CarBehaviour){
        listToPlay.append(behaviour == .acceleration ? .newaxe_acc : .newaxe_fre)
        if !(isPlaying()){
            launchSong()
        }
    }
    
    func launchSong(){
        print("je lance")
        print("JE LANCE LE SON",listToPlay)
        if listToPlay.isEmpty { return }
        guard let url = Bundle.main.url(forResource: listToPlay.last!.description , withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player!.delegate = self
            player!.play()
        } catch {
            print(error.localizedDescription)
        }
        
        listToPlay.removeLast()
        
        
        print("LA LIST APRES AVOIR TOUT LANCE",listToPlay)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("J'ai fini")
        launchSong()
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
       print("J'ai fini")
    }
    
}
