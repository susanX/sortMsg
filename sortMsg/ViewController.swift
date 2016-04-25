//
//  ViewController.swift
//  shortMsg
//
//  Created by s gooding on 15/04/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.
//

import UIKit
import AVFoundation
import CloudKit

class ViewController: AudioViewController,AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio! //model
    
    var recordingTimer : NSTimer!
    
//    @IBAction func unwind(segue:UIStoryboardSegue) {
//       // clear all values
//        print("unwound back to Record")
//    }
    
    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var playRecording: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageSent: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Record"
//        let navigationBar = navigationController!.navigationBar
//        navigationBar.tintColor = UIColor.blueColor()
//        
//        let leftButton =  UIBarButtonItem(title: "Left Button", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
//        let rightButton = UIBarButtonItem(title: "Right Button", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
//        
//        navigationItem.leftBarButtonItem = leftButton
//        navigationItem.rightBarButtonItem = rightButton
        
        recordAudio.hidden = false
        recordingLabel.hidden = true
        playRecording.hidden = true
        stopRecording.hidden = true
        sendButton.hidden = true
        messageSent.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide stop button
        stopRecording.hidden = true
        recordAudio.enabled = true
        playRecording.hidden = true
        recordingLabel.enabled = true
        sendButton.hidden = true
         messageSent.hidden = true
    }
    //ref scheduledTimerWithTimeInterval.// https://github.com/yimajo/SwiftReferenceCycleDemo// accessed 16/04/16
    
    @IBAction func RecordAudio(sender: AnyObject) {
        recordingLabel.hidden = false
        stopRecording.hidden = false
        recordAudio.enabled = false
        playRecording.hidden = true
         messageSent.hidden = true
        
        // Record use model recordedAudio.filePathUrl
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        //        print("filePath\(filePath)")
        //        let audioURL = NSURL(fileURLWithPath:recordingName)
        //        print("....filePath......\(filePath)")
        //        print("....unwrapped filePath_______\(filePath!)")
        //new
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
        } catch _ {
        }
        do {
            // use speaker instead
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch _ {
        }
        
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: [String: AnyObject]())
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
       
        //new Swift 2.2
        //selector: #selector(StopRecording)
        //selector: "StopRecording:"
       // selector: #selector(StopRecording),
        if recordingTimer == nil {
            recordingTimer = NSTimer.scheduledTimerWithTimeInterval(
                5,
                target: self,
                selector: #selector(StopRecording),
                userInfo: nil,
                repeats: false)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool){
        if(flag){
            // save the recorded audio. Use initializer to init the instance.
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, text: recorder.url.lastPathComponent!)
            
        } else {
            print("Recording was not successful")
            recordAudio.enabled = true
            stopRecording.hidden = false
             messageSent.hidden = true
            
        }
        print("MODEL recordedAudio_________________________________________")
        print("recordedAudio.filePathUrl:\(recordedAudio.filePathUrl)")
        print("_________________________________________")
    }
    
    
    @IBAction func playNormal(sender: AnyObject) {
        playSound(recordedAudio.filePathUrl)
        stopRecording.hidden = true
    }
    
    @IBAction func StopRecording(sender: AnyObject) {
        audioRecorder.stop()
        recordingLabel.hidden = true
        recordAudio.hidden = true
        playRecording.hidden = false
        messageSent.hidden = true
        sendButton.hidden = false
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        
        if recordingTimer != nil {
            recordingTimer.invalidate()
            recordingTimer = nil
        }
    }
    
    func messageIsSent(){
        stopRecording.hidden = true
        messageSent.hidden = false
        self.messageSent.text   = "Message sent"
        stopRecording.hidden = true
        
        audioRecorder.stop()
        recordingLabel.hidden = true
        recordAudio.hidden = true
        playRecording.hidden = true
        messageSent.hidden = true
        sendButton.hidden = true
        
       recordAudio.hidden = false
        
    }
    
    @IBAction func sendButton(sender: AnyObject) {
        playRecording.hidden = true
        let uniqueReference = NSUUID().UUIDString
        let uniqueRecordID = CKRecordID(recordName: uniqueReference)
        
        let itemRecord: CKRecord = CKRecord(recordType: "Messages", recordID:uniqueRecordID)//, recordID:itemRecordID)
        let audioURL = recordedAudio.filePathUrl
        
        let file:CKAsset? = CKAsset(fileURL: audioURL)//fileURL is type NSURL
        
        itemRecord["AudioFile"] = file
        
        //date
        itemRecord["Sent"] =
           NSDateFormatter.localizedStringFromDate(NSDate(),
               dateStyle:NSDateFormatterStyle.MediumStyle,
               timeStyle:NSDateFormatterStyle.ShortStyle)
        //dateFormatter.dateFormat = "HH:mma eeee d MMMM"
            
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var userName = "Unknown"
        
        if userDefaults.valueForKey("userName") != nil
        {
            userName = userDefaults.valueForKey("userName") as! NSString as String
        }
        itemRecord["userName"] = userName
        
        ////
        var tag = "Unknown"
        
        if userDefaults.valueForKey("tag") != nil
        {
            tag = userDefaults.valueForKey("tag") as! NSString as String
        }
        itemRecord["tag"] = tag
        
        db.saveRecord(itemRecord) {(record:CKRecord?, error:NSError?) -> Void in
            if error == nil {
                print("audio saved!")
                print(record!["userName"])
                print(record!["Sent"])
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.messageIsSent()
            })
            }
        }
        //call last function to hide Send and show Message sent
        
        
    }
    
    
}