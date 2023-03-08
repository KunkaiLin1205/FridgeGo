import UIKit

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // reference var
    @IBOutlet weak var topHalfView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var sectionSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var Ntable: UITableView!
    @IBOutlet weak var textInfo: UITextView!
    
    @IBOutlet weak var out1: UIView!
    @IBOutlet weak var out2: UIView!
    
    @IBOutlet weak var h1: NSLayoutConstraint!
    @IBOutlet weak var w1: NSLayoutConstraint!
    @IBOutlet weak var w2: NSLayoutConstraint!
    @IBOutlet weak var h3: NSLayoutConstraint!
    @IBOutlet weak var w3: NSLayoutConstraint!
    @IBOutlet weak var c1: NSLayoutConstraint!
    @IBOutlet weak var c2: NSLayoutConstraint!
    @IBOutlet weak var h4: NSLayoutConstraint!
    
    // other var
    weak var item : Item?
    var section = 0
    var old_section = "0"
    var row = 0
    var date : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.button1.layer.cornerRadius = 10
        self.button1.backgroundColor = UIColor.red
        self.button1.tintColor = UIColor.white
        
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
        
        // load
        self.foodName.text = item?.itemName
        self.num.text = String(item!.num)
        self.date = item?.expDate
        if (self.section == 0) {
            self.sectionName.text = "保鲜"
            self.old_section = "0"
            self.sectionSwitch.isOn = true
        } else {
            self.sectionName.text = "冷藏"
            self.old_section = "1"
            self.sectionSwitch.isOn = false
        }
        
        let s = self.item?.expDate!.split(separator: "-")
        var dateComp = DateComponents(year: Int(s![0]), month: Int(s![1]), day: Int(s![2]))
        let date = Calendar.current.date(from: dateComp)!
        self.datePicker.date = date
        
        self.textInfo.text = item?.com
        
        switch item?.category {
        case 0:
            self.imageView.image = UIImage(named: "veg3")
            self.category.text = "蔬菜"
        case 1:
            self.imageView.image = UIImage(named: "fruit3")
            self.category.text = "水果"
        case 2:
            self.imageView.image = UIImage(named: "drink3")
            self.category.text = "饮品"
        case 3:
            self.imageView.image = UIImage(named: "cream3")
            self.category.text = "冷冻"
        case 4:
            self.imageView.image = UIImage(named: "egg3")
            self.category.text = "蛋奶制"
        case 5:
            self.imageView.image = UIImage(named: "seafood3")
            self.category.text = "海鲜"
        case 6:
            self.imageView.image = UIImage(named: "meat3")
            self.category.text = "肉类"
        default:
            self.imageView.image = UIImage(named: "others3")
            self.category.text = "其他"
        }
        
        if (item?.brief != "-1") {
            self.textView.text = item?.brief
        } else {
            self.textView.text = "暂无相关介绍..."
        }
        // set label
        self.out1.layer.cornerRadius = 15
        self.out1.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.out1.layer.borderWidth = 1
        self.out1.layer.borderColor = UIColor.red.cgColor
        self.out2.layer.cornerRadius = 15
        self.out2.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0)
        self.out2.layer.borderWidth = 1
        self.out2.layer.borderColor = UIColor.red.cgColor
        
        // set constraints
        self.c1.constant = self.view.frame.width / 4
        self.c2.constant = self.view.frame.width / 4
        self.h1.constant = self.view.frame.height / 2.2
        self.w1.constant = self.view.frame.width
        self.w2.constant = self.view.frame.width / 2 + 8
        self.h3.constant = self.smallView.frame.width * 0.7
        self.w3.constant = self.smallView.frame.width * 0.7
        self.h4.constant = self.view.frame.height / 6

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
    
    @IBAction func changeDate(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let strDate = dateFormatter.string(from: datePicker.date)
        
        self.date = strDate
    }
    
    @IBAction func sectionChange(_ sender: Any) {
        if (self.section == 0) {
            self.section = 1
            self.sectionName.text = "冷藏"
        } else {
            self.section = 0
            self.sectionName.text = "保鲜"
        }
    }
    
    @IBAction func saveChange(_ sender: Any) {
        var info = [String: String]()
        info["name"] = foodName.text!
        info["date"] = date!
        info["section"] = String(section)
        info["old_section"] = old_section
        info["old_row"] = String(row)
        info["num"] = num.text!
        info["c"] = String(Int(item!.category))
        info["comment"] = self.textInfo.text
        info["protein"] = String(item!.protein)
        info["fat"] = String(item!.fat)
        info["vc"] = String(item!.vc)
        info["carbo"] = String(item!.carbo)
        info["cal"] = String(item!.cal)
        info["brief"] = self.textView.text
        
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("com.modify"), object: nil, userInfo: info)
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
                    if (item!.protein == -1) {
                        cell.value.text = "???"
                    } else {
                        cell.value.text = String(item!.protein) + " 克"
                    }
                case 1:
                    cell.title.text = "脂肪"
                    if (item!.fat == -1) {
                        cell.value.text = "???"
                    } else {
                        cell.value.text = String(item!.fat) + " 克"
                    }
                case 2:
                    cell.title.text = "维生素C"
                    if (item!.vc == -1) {
                        cell.value.text = "???"
                    } else {
                        cell.value.text = String(item!.vc)
                    }
                case 3:
                    cell.title.text = "碳水"
                    if (item!.carbo == -1) {
                        cell.value.text = "???"
                    } else {
                        cell.value.text = String(item!.carbo) + " 克"
                    }
                default:
                    cell.title.text = "卡路里"
                    if (item!.cal == -1) {
                        cell.value.text = "???"
                    } else {
                        cell.value.text = String(item!.cal) + " 大卡"
                    }
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

