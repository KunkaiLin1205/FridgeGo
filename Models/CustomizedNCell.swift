import UIKit

class CustomizedNCell: UITableViewCell {

    @IBOutlet weak var c1: NSLayoutConstraint!
    @IBOutlet weak var c2: NSLayoutConstraint!
    @IBOutlet weak var h: NSLayoutConstraint!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
