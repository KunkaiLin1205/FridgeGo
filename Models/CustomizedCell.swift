import UIKit
import SwipeCellKit

class CustomizedCell: SwipeTableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
