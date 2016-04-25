//
//  ButtonCell.swift
//  CellButtons
//
//  Created by Jure Zove on 20/09/15.
//  Copyright © 2015 Candy Code. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate {
    func cellTapped(cell: ButtonCell)
}

class ButtonCell: UITableViewCell {
    
    var buttonDelegate: ButtonCellDelegate?
    
  

//    @IBAction func buttonTap(sender: AnyObject) {
//        if let delegate = buttonDelegate {
//            delegate.cellTapped(self)
//        }
//    }
    @IBOutlet weak var userLabel: UILabel!
        @IBOutlet weak var timeLabel: UILabel!
}
