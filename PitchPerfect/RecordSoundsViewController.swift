//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Ravi Rathore on 11/28/15.
//  Copyright © 2015 Banago labs. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController {
    
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        
        stopRecordingButton.hidden = true
        recordingLabel.hidden = true
    
    }

    @IBAction func startRecording(sender: UIButton) {
        
        recordingLabel.hidden = false
        stopRecordingButton.hidden = false
        recordButton.enabled = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
       // let currentDateTime = NSDate()
        //let formatter = NSDateFormatter()
        //formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.hidden=true
        recordButton.enabled = true
        stopRecordingButton.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if ( segue.identifier == "stopRecording" )
        {
            let playSoundsVC : PlaySoundViewController = segue.destinationViewController   as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
  
}

extension RecordSoundsViewController : AVAudioRecorderDelegate{
    

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //todo1 save the recorded audio
   
        if (flag) {
        let recordedAudio = RecordedAudio()
        recordedAudio.title = audioRecorder.url.lastPathComponent
        recordedAudio.filePathUrl = audioRecorder.url
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
      else
        {
          
            recordingLabel.hidden = true
            recordButton.enabled = true
            stopRecordingButton.hidden = true
        }
    }
}

