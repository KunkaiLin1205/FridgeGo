//
//  CustomizedCategoryCell.swift
//  FreshReminder_v0
//
//  Created by Mac on 2022/12/26.
//

import UIKit

class CustomizedCategoryCell: UITableViewCell {

    @IBOutlet weak var c1: NSLayoutConstraint!
    @IBOutlet weak var c2: NSLayoutConstraint!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        c1.constant = self.frame.width / 10
        c2.constant = -self.frame.width / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
