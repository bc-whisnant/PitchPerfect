//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Whisnant, Brandon on 12/19/17.
//  Copyright © 2017 Whisnant, Brandon. All rights reserved.
//

import UIKit

import AVFoundation
//class conforms to avnaudiorecorderdelegate protocol
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
    }
    
    func configureUI(isRecording: Bool) {
        if isRecording {
            print("record button was pressed.")
            recordingLabel.text = "Recording in Progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
            
        } else {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
        }
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        configureUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //tells the recordAudio function that this view contorller is delegate
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
         configureUI(isRecording: false)
        audioRecorder.stop()
        //isRecording = false
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //print("audio recorder has finished")
        //added segue so the url location can be sent to the second screen
        if flag {
        performSegue(withIdentifier:"stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            //grab the sender here
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    

    
}

