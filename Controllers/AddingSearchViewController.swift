import UIKit

class AddingSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // reference var
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var topHalfView: UIView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var referDays: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var freshLabel: UILabel!
    @IBOutlet weak var changeFresh: UISwitch!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var Ntable: UITableView!
    @IBOutlet weak var textInfo: UITextView!
    
    @IBOutlet weak var out1: UIView!
    @IBOutlet weak var out2: UIView!
    @IBOutlet weak var out3: UIView!
    
    @IBOutlet weak var c1: NSLayoutConstraint!
    @IBOutlet weak var c2: NSLayoutConstraint!
    @IBOutlet weak var h1: NSLayoutConstraint!
    @IBOutlet weak var w1: NSLayoutConstraint!
    @IBOutlet weak var w2: NSLayoutConstraint!
    @IBOutlet weak var h3: NSLayoutConstraint!
    @IBOutlet weak var w3: NSLayoutConstraint!
    @IBOutlet weak var h5: NSLayoutConstraint!
    
    // other var
    var item : searchItem?
    var ifFresh : String?
    var dateExpiration : String?
    var dateToday : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        
        self.completeButton.layer.cornerRadius = 10
        self.completeButton.backgroundColor = UIColor.red
        self.completeButton.tintColor = UIColor.white
        self.applyButton.layer.cornerRadius = 10
        self.applyButton.backgroundColor = UIColor.red
        self.applyButton.tintColor = UIColor.white
        
        self.topHalfView.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.smallView.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        
        self.textView.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.textView.textColor = .red
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.red.cgColor
        self.textView.layer.cornerRadius = 15
        self.textInfo.layer.cornerRadius = 15
        self.textInfo.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        // table
        self.Ntable.delegate = self
        self.Ntable.dataSource = self
        self.Ntable.register(UINib(nibName: "CustomizedNCell", bundle: nil),
                               forCellReuseIdentifier: "NCell")
        self.Ntable.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.Ntable.rowHeight = self.view.frame.height / 30
        
        // small views
        self.out1.layer.cornerRadius = 15
        self.out1.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.out1.layer.borderWidth = 1
        self.out1.layer.borderColor = UIColor.red.cgColor
        self.out2.layer.cornerRadius = 15
        self.out2.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.out2.layer.borderWidth = 1
        self.out2.layer.borderColor = UIColor.red.cgColor
        self.out3.layer.cornerRadius = 15
        self.out3.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.out3.layer.borderWidth = 1
        self.out3.layer.borderColor = UIColor.red.cgColor
        
        // date
        self.datePicker.minimumDate = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let strDate = dateFormatter.string(from: datePicker.date)

        self.dateExpiration = strDate
        self.dateToday = strDate
        
        // load
        self.itemName.text = item!.itemName
        self.category.text = item!.category
        self.num.text = "1"
        self.freshLabel.text = "保鲜"
        self.ifFresh = "0"
        self.referDays.text = "\(item!.qualityDay)天"
        self.textView.text = item!.brief
        switch item!.category {
        case "蔬菜":
            self.imageView.image = UIImage(named: "veg3")
        case "水果":
            self.imageView.image = UIImage(named: "fruit3")
        case "蛋奶制品":
            self.imageView.image = UIImage(named: "egg3")
        case "海鲜":
            self.imageView.image = UIImage(named: "seafood3")
        default:
            self.imageView.image = UIImage(named: "meat3")
        }
        
        self.Ntable.reloadData()
        
        // set constraints
        self.c1.constant = self.view.frame.width / 4
        self.c2.constant = self.view.frame.width / 4
        self.h1.constant = self.view.frame.height / 2.2
        self.w1.constant = self.view.frame.width
        self.w2.constant = self.view.frame.width / 2 + 8
        self.h3.constant = self.smallView.frame.width * 0.7
        self.w3.constant = self.smallView.frame.width * 0.7
        self.h5.constant = self.view.frame.height / 6
    }
    
    @IBAction func add(_ sender: Any) {
        if (self.num.text == "99") {
            return
        } else {
            let oldNum = Int(self.num.text!)!
            self.num.text = String(oldNum + 1)
        }
    }
    
    @IBAction func minus(_ sender: Any) {
        if (self.num.text == "1") {
            return
        } else {
            let oldNum = Int(self.num.text!)!
            self.num.text = String(oldNum - 1)
        }
    }
    
    @IBAction func dateChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let strDate = dateFormatter.string(from: datePicker.date)
        
        self.dateExpiration = strDate
    }
    
    @IBAction func apply(_ sender: Any) {
        let s = self.dateToday!.split(separator: "-")
        
        var dateComp = DateComponents(year: Int(s[0]), month: Int(s[1]), day: Int(s[2]))
        var date = Calendar.current.date(from: dateComp)!
        date = Calendar.current.date(byAdding: .day, value: self.item!.qualityDay, to: date)!
        
        self.datePicker.date = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePicker.date)
        self.dateExpiration = strDate
    }
    
    @IBAction func valueChange(_ sender: Any) {
        if self.ifFresh == "0" {
            self.freshLabel.text = "冷藏"
            self.ifFresh = "1"
        } else {
            self.freshLabel.text = "保鲜"
            self.ifFresh = "0"
        }
    }
    
    // table functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NCell") as? CustomizedNCell {
                switch indexPath.row {
                case 0:
                    cell.title.text = "蛋白质"
                    cell.value.text = String(item!.protein) + " 克"
                case 1:
                    cell.title.text = "脂肪"
                    cell.value.text = String(item!.fat) + " 克"
                case 2:
                    cell.title.text = "维生素C"
                    cell.value.text = String(item!.vc)
                case 3:
                    cell.title.text = "碳水"
                    cell.value.text = String(item!.carbo) + " 克"
                default:
                    cell.title.text = "卡路里"
                    cell.value.text = String(item!.cal) + " 大卡"
                }
                
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.red.cgColor
                cell.title.textColor = .red
                cell.value.textColor = .red
                cell.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
                cell.h.constant = cell.frame.height
                cell.c1.constant = -cell.frame.width / 4
                cell.c2.constant = cell.frame.width / 4
                
                return cell
            }
            
            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    }
    
    @IBAction func adding(_ sender: Any) {
        var info = [String: String]()
        info["name"] = item!.itemName
        info["date"] = self.dateExpiration
        info["section"] = self.ifFresh
        info["num"] = self.num.text!
        switch item!.category {
        case "蔬菜":
            info["category"] = "0"
        case "水果":
            info["category"] = "1"
        case "蛋奶制品":
            info["category"] = "4"
        case "海鲜":
            info["category"] = "5"
        default:
            info["category"] = "6"
        }
        info["comment"] = self.textInfo.text!
        info["protein"] = String(item!.protein)
        info["fat"] = String(item!.fat)
        info["vc"] = String(item!.vc)
        info["carbo"] = String(item!.carbo)
        info["cal"] = String(item!.cal)
        info["brief"] = item!.brief
        
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("com.main"), object: nil, userInfo: info)
        NotificationCenter.default.post(name: Notification.Name("com.finishadding"), object: nil, userInfo: info)
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
