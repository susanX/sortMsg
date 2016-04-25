//
//  AudioViewController.swift
//  shortMsg
//
//  Created by s gooding on 16/04/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class AudioViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var db:CKDatabase!
    var itemRecord:[CKRecord] = []
    
    /////FETCH///////////////
    func fetchMyAsset(completion: ([CKRecord]?, NSError?) -> Void ){
        
        let predicate = NSPredicate(value: true)
        let myQuery = CKQuery(recordType: "Messages", predicate: predicate)
        
        db.performQuery(myQuery, inZoneWithID: nil) {
            
            //2 objects in the completionhandler will execute
            records, error in
            if error != nil{
                print(error!.localizedDescription)
                completion(records, error)
            }else {
                
                for element in records! {
                    
                    self.itemRecord.append(element as CKRecord)
                    
                    print(element)
                }
                completion(records, error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background,atIndex: 0)
        
        db = CKContainer.defaultContainer().publicCloudDatabase
        
    }
 
    func playSound(url : NSURL) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer.enableRate = true
        audioPlayer.play()
    }
}
