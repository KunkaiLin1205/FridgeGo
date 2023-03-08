import UIKit

class AddingDetailVCViewController: UIViewController {
    // referencce var
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var foodName: UITextField!
    @IBOutlet weak var freshLabel: UILabel!
    @IBOutlet weak var changeFresh: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textInfo: UITextView!
    
    @IBOutlet weak var out1: UIView!
    @IBOutlet weak var out2: UIView!
    @IBOutlet weak var out3: UIView!
    @IBOutlet weak var w1: NSLayoutConstraint!
    @IBOutlet weak var c1: NSLayoutConstraint!
    @IBOutlet weak var c2: NSLayoutConstraint!
    @IBOutlet weak var c3: NSLayoutConstraint!
    @IBOutlet weak var c4: NSLayoutConstraint!
    @IBOutlet weak var c5: NSLayoutConstraint!
    @IBOutlet weak var c6: NSLayoutConstraint!
    @IBOutlet weak var c7: NSLayoutConstraint!
    @IBOutlet weak var c8: NSLayoutConstraint!
    @IBOutlet weak var c9: NSLayoutConstraint!
    @IBOutlet weak var imageH: NSLayoutConstraint!
    @IBOutlet weak var imageW: NSLayoutConstraint!
    
    
    // other var
    var category : Int?
    var ifFresh : String?
    var dateExpiration : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.completeButton.layer.cornerRadius = 10
        self.completeButton.backgroundColor = UIColor.red
        self.completeButton.tintColor = UIColor.white
        
        self.textInfo.layer.cornerRadius = 15
        self.textInfo.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.num.text = "1"
        
        switch category {
        case 0:
            self.categoryName.text = "蔬菜"
            self.imageView.image = UIImage(named: "veg3")
        case 1:
            self.categoryName.text = "水果"
            self.imageView.image = UIImage(named: "fruit3")
        case 2:
            self.categoryName.text = "饮品"
            self.imageView.image = UIImage(named: "drink3")
        case 3:
            self.categoryName.text = "冷冻"
            self.imageView.image = UIImage(named: "cream3")
        case 4:
            self.categoryName.text = "蛋奶制"
            self.imageView.image = UIImage(named: "egg3")
        case 5:
            self.categoryName.text = "海鲜"
            self.imageView.image = UIImage(named: "seafood3")
        case 6:
            self.categoryName.text = "肉类"
            self.imageView.image = UIImage(named: "meat3")
        default:
            self.categoryName.text = "其他"
            self.imageView.image = UIImage(named: "others3")
        }
        
        self.freshLabel.text = "保鲜"
        self.ifFresh = "0"
        
        self.datePicker.minimumDate = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let strDate = dateFormatter.string(from: datePicker.date)

        self.dateExpiration = strDate
        
        // small views
        self.out1.layer.cornerRadius = 15
        self.out1.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.out1.layer.borderWidth = 1
        self.out1.layer.borderColor = UIColor.red.cgColor
        self.out2.layer.cornerRadius = 15
        self.out2.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.out2.layer.borderWidth = 1
        self.out2.layer.borderColor = UIColor.red.cgColor
        self.out3.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        
        // constraints
        self.w1.constant = self.view.frame.width * 0.8
        self.c1.constant = -self.view.frame.width / 4
        self.c2.constant = -self.view.frame.width / 4
        self.c3.constant = self.view.frame.width / 5
        self.c4.constant = self.view.frame.width / 5
        self.c5.constant = self.view.frame.height / 5
        self.c6.constant = -self.view.frame.width / 4
        self.c7.constant = -self.view.frame.width / 4
        self.c8.constant = self.view.frame.width / 5
        self.c9.constant = self.view.frame.width / 5
        self.imageH.constant = self.out3.frame.height * 0.5
        self.imageW.constant = self.out3.frame.height * 0.5

    }
    
    @IBAction func minus(_ sender: Any) {
        if (self.num.text == "1") {
            return
        } else {
            let oldNum = Int(self.num.text!)!
            self.num.text = String(oldNum - 1)
        }
    }
    
    @IBAction func add(_ sender: Any) {
        if (self.num.text == "99") {
            return
        } else {
            let oldNum = Int(self.num.text!)!
            self.num.text = String(oldNum + 1)
        }
    }
    
    @IBAction func changeFresh(_ sender: Any) {
        if self.ifFresh == "0" {
            self.freshLabel.text = "冷藏"
            self.ifFresh = "1"
        } else {
            self.freshLabel.text = "保鲜"
            self.ifFresh = "0"
        }
    }
    
    @IBAction func dateChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let strDate = dateFormatter.string(from: datePicker.date)
        
        self.dateExpiration = strDate
    }
    
    @IBAction func adding(_ sender: Any) {
        var info = [String: String]()
        info["name"] = self.foodName.text!
        info["date"] = self.dateExpiration
        info["section"] = self.ifFresh
        info["num"] = self.num.text!
        info["category"] = String(self.category!)
        info["comment"] = self.textInfo.text!
        info["protein"] = "-1"
        info["fat"] = "-1"
        info["vc"] = "-1"
        info["carbo"] = "-1"
        info["cal"] = "-1"
        info["brief"] = "-1"
        
        dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: Notification.Name("com.main"), object: nil, userInfo: info)
    }
    
    @IBAction func editComment(_ sender: Any) {
        var textField = UITextField()
           
        let alert = UIAlertController(title: "编辑备注", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "请输入您的备注..."
            textField = alertTextField
        }
           
        let action_1 = UIAlertAction(title: "确定", style: .default) { (action_1) in
            self.textInfo.text = textField.text!
        }
           
        let action_2 = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        alert.addAction(action_1)
        alert.addAction(action_2)
        
        present(alert, animated: true)
    }

}
