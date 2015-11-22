//
//  SwitchCell.swift
//  Yelp
//
//  Created by Giao Tuan on 11/19/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import SevenSwitch

class SwitchCell: UITableViewCell {

    @IBOutlet weak var onSwitch: SevenSwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate : SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchValueChange(sender: SevenSwitch) {
         delegate?.switchCell(self, didValueChange: sender.on)
    }
 
}

protocol SwitchCellDelegate {
    func switchCell(switchCell : SwitchCell, didValueChange value : Bool)
}
    