//
//  RecordSoundsViewController.swift
//  Pitch Perfect (project #1 in iOS Developer Nanodegree)
//  Record audio and then call another view controller to play it.
//
//  Created by Pekka Kaariainen on 04/04/15.
//  Copyright (c) 2015 Pekka Kaariainen. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var isRecording: Bool = false
    
    @IBOutlet weak var recordingState: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    struct myConstants {
        static let recordingNotInProgress = "Tap mic to record"
        static let recordingInProgress = "Recording"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isRecording = true; //reset to not recording by calling toggle
        toggleImagesAndLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {

        toggleImagesAndLabels()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {

        toggleImagesAndLabels()
        audioRecorder.stop()
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title:recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            //println("ERROR: Recording was not succesfull!")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func toggleImagesAndLabels(){
        //update mic image, label and stop button depending of the recording state
        if isRecording == true {
            recordingState.text = myConstants.recordingNotInProgress
            isRecording = false
            recordButton.enabled = true
            stopRecordingButton.hidden = true
        } else {
            recordingState.text = myConstants.recordingInProgress
            isRecording = true
            recordButton.enabled = false
            stopRecordingButton.hidden = false
        }
    }
}

