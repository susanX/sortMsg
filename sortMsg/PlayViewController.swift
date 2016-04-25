//
//  PlayViewController.swift
//  shortMsg
//
//  Created by s gooding on 16/04/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CloudKit

class PlayViewController: AudioViewController {
    
   var userName = ""
   var tagName = ""
    
   let userDefaults = NSUserDefaults.standardUserDefaults()
   
    
  
    
   @IBOutlet weak var userInput: UITextField!
   @IBOutlet weak var tagInput: UITextField!
   @IBOutlet weak var userLabel: UILabel!
   @IBOutlet weak var tagLabel: UILabel!
    
    //Reference for dismissing keboard: https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson4.html FoodTracker.swift
    func hideKeyboard(textField:UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    //1. tag
    @IBAction func sendUserButton(sender: AnyObject) {
        if userInput.text == "" || userInput.text == nil {
            userInput.text = "unknown"
        }
        userName = userInput.text!
        userLabel.text = userName
        
        self.userDefaults.setValue(userName,forKey:"userName")
        self.userDefaults.synchronize()
        hideKeyboard(userInput)
        }
    
    
   //2. userName
   @IBAction func sendTagButton(sender: AnyObject) {
        if tagLabel.text == "" || tagInput.text == nil {
             tagInput.text = "no_group"
        }
        tagName = tagInput.text!
        tagLabel.text = tagName
    
        self.userDefaults.setValue(tagName,forKey:"tag")
        self.userDefaults.synchronize()
    
        hideKeyboard(tagInput)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        if(self.userDefaults.valueForKey("userName") != nil)
        {
            userName = self.userDefaults.valueForKey("userName") as! NSString as String
            userLabel.text = String("My username is \(userName)")
            print(userDefaults)
            print("My username is \(userName)")
         }
            
         if(self.userDefaults.valueForKey("tag") != nil)
         {
            tagName = self.userDefaults.valueForKey("tag") as! NSString as String
            tagLabel.text = String("My Tag is \(tagName)")
            print(userDefaults)
            print("My tag is \(tagName)")
         }
    }
}
