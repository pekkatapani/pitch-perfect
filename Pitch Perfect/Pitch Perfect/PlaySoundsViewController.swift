//
//  PlaySoundsViewController.swift
//  Pitch Perfect (project #1 in iOS Developer Nanodegree)
//  Play audio with changed speed or pitch
//
//  Created by Pekka Kaariainen on 05/04/15.
//  Copyright (c) 2015 Pekka Kaariainen. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayerNode:AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func PlaySlowAudio(sender: UIButton) {
        playAudio(0.5)
    }

    @IBAction func PlayFastAudio(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-700)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
    
    func stopAllAudio(){
        
        if(audioPlayer.playing){
            audioPlayer.stop()
        }
        
        if(audioEngine != nil){
            audioEngine.stop()
            audioEngine.reset()
        }
        
        if(audioPlayerNode != nil){
            audioPlayerNode.stop()
        }
    }
    
    func playAudio(rate: Float){

        stopAllAudio()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        stopAllAudio()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
}