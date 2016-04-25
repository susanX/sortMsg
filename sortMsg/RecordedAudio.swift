//
//  RecordedAudio.swift
//  VoiceMess_2March
//
//  Created by s gooding on 02/03/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var recordID: String!
    var taglab: String!
    var userName: String!
    var Sent: NSDate!
    var creationDate: NSDate!
   // var recordID: CKRecordID!
    
   var audio: NSURL!
    
    
    
    init(filePathUrl: NSURL,text: String){
        self.filePathUrl = filePathUrl

    }
}