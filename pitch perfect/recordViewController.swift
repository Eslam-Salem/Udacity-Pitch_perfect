//
//  ViewController.swift
//  pitch perfect
//
//  Created by Eslam  on 1/22/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import AVFoundation

class recordViewController: UIViewController ,AVAudioRecorderDelegate{

    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordStatus: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // at the start make the view starts with this
        buttonAndLabelStatus(recordButton: false, stopButton: true, labelStatus: "Tap to record")
    }

    @IBAction func recordButton(_ sender: Any) {
        // what hapeen when i click record
        buttonAndLabelStatus(recordButton: true, stopButton: false, labelStatus: "recording ... tap to stop")
        // save the recorded file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordButton(_ sender: Any) {
        //the recorded fininshed and ready to use it
        buttonAndLabelStatus(recordButton: false, stopButton: true, labelStatus: "Done!..Tap to record again ")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    // be ready to move from this vc if it is successfuly recorded
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "finishRecording", sender: audioRecorder.url)
        }
        else{
            buttonAndLabelStatus(recordButton: false, stopButton: true, labelStatus: "Failed .. try again")
        }
    }
    // go to playsoundviewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishRecording"
        {
            let playSoundVC = segue.destination as! playSoundViewController
            let recordedAudioUrl =  sender as! URL
            playSoundVC.recordAudioURL = recordedAudioUrl
        }
    }
    //to make the status of the buttons and labels
    func buttonAndLabelStatus (recordButton: Bool ,stopButton: Bool , labelStatus: String)
    {
        self.recordButton.isHidden = recordButton
        self.stopRecordButton.isHidden = stopButton
        self.recordStatus.text = labelStatus
    }
}

