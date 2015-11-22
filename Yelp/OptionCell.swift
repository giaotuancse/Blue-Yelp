//
//  OptionCell.swift
//  Yelp
//
//  Created by Giao Tuan on 11/19/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionImage: UIImageView!

    var delegate : OptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            delegate?.optionCell(self, onRowSelect: selected)
        // Configure the view for the selected state
    }

}

protocol OptionCellDelegate {
    func optionCell(optionCell : OptionCell, onRowSelect selected : Bool)
}
