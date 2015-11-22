//
//  BussinessCellTableViewCell.swift
//  Yelp
//
//  Created by Giao Tuan on 11/17/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BussinessCellTableViewCell: UITableViewCell {
    
  
    @IBOutlet weak var reivewLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
