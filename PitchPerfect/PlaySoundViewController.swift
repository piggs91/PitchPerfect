//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Ravi Rathore on 11/30/15.
//  Copyright © 2015 Banago labs. All rights reserved.
//
//Tasks
/* get a way to identify that replay has ended so that we can hide the]
stop button
*/
import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    var audioPlayer : AVAudioPlayer?
    var receivedAudio : RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    //  var val$ = 1
   // var $val = 1
    
    @IBOutlet weak var stopButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //if let Path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
      //  {
           // let url = NSURL.fileURLWithPath(Path)
           do
           {
            try audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
            audioPlayer?.delegate = self
            }
            catch
            {
               print("unable to get audioPlater instance")
            }
        //}
        audioEngine = AVAudioEngine()
      audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSound(sender: UIButton) {
        
    audioPlayer?.enableRate = true
        audioPlayer?.rate = 0.5
      audioPlayer?.stop()
        audioPlayer?.currentTime = 0.0
      audioPlayer?.play()
        stopButton.hidden = false
        
        
    }

    @IBAction func playFast(sender: UIButton) {
        audioPlayer?.stop()
        audioPlayer?.enableRate = true
        audioPlayer?.rate = 2.0
        audioPlayer?.currentTime = 0.0
        audioPlayer?.play()
         stopButton.hidden = false
    }
    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer?.stop()
        stopButton.hidden = true
    }
    @IBAction func playChipMunkAudio(sender: UIButton) {
        
     playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthSound(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    func playAudioWithVariablePitch(pitch: Float)
    {
        audioPlayer?.stop()
        audioEngine.stop()
        audioEngine.reset()
        let audioPlayerNode  = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PlaySoundViewController : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print(flag)
        stopButton.hidden = true
    }
}
