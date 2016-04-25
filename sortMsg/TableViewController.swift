//
//  TableViewController.swift
//  CellButtons
//  Created by s gooding on 02/03/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.

//  ref Jure Zove on 20/09/15.
//  Copyright © 2015 Candy Code. ///////
//  ////candycode.io/how-to-properly-do-buttons-in-table-view-cells/
//
import AVFoundation
import UIKit
import CloudKit

class TableViewController: UITableViewController, ButtonCellDelegate {
   
    var audioPlayer:AVAudioPlayer!
    var db:CKDatabase!
    var itemRecord:[CKRecord] = []
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    /////FETCH///////////////
    //NavigationBar syntax ref: (not for nav title???)https://developer.apple.com/library/ios/samplecode/CloudAtlas/Listings/iOS_CloudKitCatalog_CloudKitCatalog_NavigationBar_swift.html
    
    //Predicate ref: https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html#//apple_ref/doc/uid/TP40001793-CJBDBHCB title, Format String Summary accessed on 20/04/16
    
    func fetchMyAsset(completion: ([CKRecord]?, NSError?) -> Void ){
        
//TODO remove hardcode Group1
        
         let matchTag = userDefaults.valueForKey("tag") as! String
        
       // let predicate = NSPredicate(format: "tag == %@", "Group1")
        let predicate = NSPredicate(format: "tag == %@",  matchTag)
        
        
        
        
        //ref// Hacking with Swift
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let myQuery = CKQuery(recordType: "Messages", predicate: predicate)
        myQuery.sortDescriptors = [sort]
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
        
        //navigationItem.title //= RecordedAudio.taglab //"One"
        // Do any additional setup after loading the view, typically from a nib.
//        let background = CAGradientLayer().turquoiseColor()
//        background.frame = self.view.bounds
//        self.view.layer.insertSublayer(background,atIndex: 0)
        
        db = CKContainer.defaultContainer().publicCloudDatabase
        fetchMyAsset { (records, error) -> Void in
            self.tableView.reloadData()
        }
        
    }
    
    func playSound(url : NSURL) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        //https://www.hackingwithswift.com/example-code/media/how-to-play-sounds-using-avaudioplayer
        audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer.enableRate = true
        audioPlayer.play()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows = itemRecord.count
        
        return rows > 0 ? rows : 1
    }
    
    //take values from iCloud
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! ButtonCell
       //problem show template cell or hide first cell
        cell.hidden = true
        
        if itemRecord.count == 0 {
            navigationItem.title = "Loading..."
           
            return cell
        }
        else{
            //wait till cell loads to show cell
             cell.hidden = false
        }
        
         let matchTag = userDefaults.valueForKey("tag") as! String
        if navigationItem.title == matchTag{
            cell.hidden = false
        }
        
        cell.userLabel.text   = itemRecord[indexPath.row]["userName"] as? String
       
        cell.timeLabel?.text   = itemRecord[indexPath.row]["Sent"] as? String
  
        navigationItem.title = itemRecord[indexPath.row]["tag"] as? String
        if cell.buttonDelegate == nil {
            cell.buttonDelegate = self
        }
        return cell
    }
    // MARK: - ButtonCellDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if itemRecord.count == 0 {
            // Reaches here if user taps the cell that says "loading"
            return
        }
        
        let row = indexPath.row
        let asset = itemRecord[row]["AudioFile"] as! CKAsset
        playSound(asset.fileURL)
    }
    
    
    func cellTapped(cell: ButtonCell) {
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print("tableview \(segue.identifier)")
  //  }

}
