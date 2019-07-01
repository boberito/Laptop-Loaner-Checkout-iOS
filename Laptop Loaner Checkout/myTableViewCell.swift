//
//  myTableViewCell.swift
//  Laptop Loaner Checkout
//
//  Created by Bob Gendler on 6/5/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var dateOutLabel: UILabel!
    @IBOutlet var dotImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
