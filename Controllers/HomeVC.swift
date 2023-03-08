import UIKit
import CoreData
import SwipeCellKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    // reference var
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var homeBackground: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var freshLabel: UILabel!
    @IBOutlet weak var frozonLabel: UILabel!
    @IBOutlet weak var labelPos: NSLayoutConstraint!
    @IBOutlet weak var freshTable: UITableView!
    @IBOutlet weak var frozenTable: UITableView!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l5: UILabel!
    @IBOutlet weak var l6: UILabel!
    
    // other var
    
    var loadedItems: [Item] = []
    var freshItems: [Item] = []
    var frozenItems: [Item] = []
    var sectionSelected: Int?
    var rowSelected: Int?
    var setDays : String?
    var h : String?
    var m : String?
    
    // default DB to save info of small size
    let defaultsDB = UserDefaults.standard
    // set context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // unchanged
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationManager.instance.requestAuthorization()
        
        // load setting info from user default
        if let tempSetDays = defaultsDB.string(forKey: "SetDays") {
            self.setDays = tempSetDays
        } else {
            self.setDays = "3"
        }
        
        if let tempName = defaultsDB.string(forKey: "TitleName") {
            self.titleName.text = tempName
        } else {
            self.titleName.text = "我的冰箱主页"
        }
        
        if let tempH = defaultsDB.string(forKey: "FRHour"), let tempM = defaultsDB.string(forKey: "FRMinute") {
            self.h = tempH
            self.m = tempM
        } else {
            self.h = "10"
            self.m = "0"
        }
        
        loadItems()
        updateDaysLeft()
        
        self.freshTable.delegate = self
        self.freshTable.dataSource = self
        freshTable.register(UINib(nibName: "CustomizedCell", bundle: nil),
                               forCellReuseIdentifier: "FreshCell")
        self.frozenTable.delegate = self
        self.frozenTable.dataSource = self
        frozenTable.register(UINib(nibName: "CustomizedCell", bundle: nil),
                               forCellReuseIdentifier: "FrozenCell")
        
        
        // background color
        self.homeBackground.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.22, green: 0.39, blue: 0.73, alpha: 1.0))
        // view color
        self.bigView.layer.cornerRadius = 10
        self.bigView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        // title color
        self.titleName.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.titleName.font = UIFont.boldSystemFont(ofSize: 20)
        self.topButton.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        
        // labels
        l1.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        l2.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        l3.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        l4.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        l5.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        l6.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        
        
        // fresh and frozon labels
        let h = self.bigView.frame.height
        let value = (h - 40) / 6
        self.labelPos.constant = value
        self.freshLabel.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.freshLabel.layer.cornerRadius = 10
        self.freshLabel.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.frozonLabel.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.frozonLabel.layer.cornerRadius = 10
        self.frozonLabel.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        
        // table setting
        self.freshTable.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
        self.freshTable.layer.cornerRadius = 10
        self.frozenTable.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
        self.frozenTable.layer.cornerRadius = 10
        
        //Observe
        NotificationCenter.default.addObserver(self, selector: #selector(add(_:)), name: Notification.Name("com.main"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modifyDaySetting(_:)), name: Notification.Name("com.modifyDS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modifyTime(_:)), name: Notification.Name("com.modifyTime"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modify(_:)), name: Notification.Name("com.modify"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modifyTheme(_:)), name: Notification.Name("com.theme"), object: nil)
    }
    
    // table functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == freshTable) {
            return freshItems.count
        } else {
            return frozenItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var iden: String?
        var temp: Item?
        if (tableView == freshTable) {
            temp = freshItems[indexPath.row]
            iden = "FreshCell"
        } else {
            temp = frozenItems[indexPath.row]
            iden = "FrozenCell"
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: iden!) as? CustomizedCell {
            switch temp!.category {
            case 0:
                cell.imageView?.image = UIImage(named: "veg")
                cell.category.text = "蔬菜"
            case 1:
                cell.imageView?.image = UIImage(named: "fruit")
                cell.category.text = "水果"
            case 2:
                cell.imageView?.image = UIImage(named: "drink")
                cell.category.text = "饮品"
            case 3:
                cell.imageView?.image = UIImage(named: "cream")
                cell.category.text = "冷冻"
            case 4:
                cell.imageView?.image = UIImage(named: "egg")
                cell.category.text = "蛋奶制"
            case 5:
                cell.imageView?.image = UIImage(named: "seafood")
                cell.category.text = "海鲜"
            case 6:
                cell.imageView?.image = UIImage(named: "meat")
                cell.category.text = "肉类"
            default:
                cell.imageView?.image = UIImage(named: "others")
                cell.category.text = "其他"
            }
            
            cell.foodName.text = temp!.itemName
            cell.num.text = String(temp!.num)
            
            if (temp!.daysLeft >= 0) {
                cell.timeLeft.text = "还剩\(String(temp!.daysLeft))天"
            } else {
                cell.timeLeft.text = "已过期\(String(-temp!.daysLeft))天"
            }
            
            cell.category.font = UIFont.boldSystemFont(ofSize: 17)
            cell.foodName.font = UIFont.boldSystemFont(ofSize: 17)
            cell.num.font = UIFont.boldSystemFont(ofSize: 17)
            cell.timeLeft.font = UIFont.boldSystemFont(ofSize: 15)
            
            cell.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
            cell.category.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
            cell.foodName.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
            cell.num.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
            cell.timeLeft.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
            
            if (temp!.daysLeft <= Int(self.setDays!)!) {
                if (temp!.daysLeft >= 0) {
                    cell.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.976, green: 0.674, blue: 0.662, alpha: 1.0), dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
                    cell.category.textColor = UIColor.white
                    cell.foodName.textColor = UIColor.white
                    cell.num.textColor = UIColor.white
                    cell.timeLeft.textColor = UIColor.white
                } else {
                    cell.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.827, green: 0.827, blue: 0.827, alpha: 1.0), dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
                    cell.category.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
                    cell.foodName.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
                    cell.num.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
                    cell.timeLeft.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
                }
            } else {
                cell.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
                cell.category.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
                cell.foodName.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
                cell.num.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
                cell.timeLeft.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor.white)
            }
            
            cell.layer.cornerRadius = 25
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == freshTable) {
            sectionSelected = 0
        } else {
            sectionSelected = 1
        }
        rowSelected = indexPath.row
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as? DetailVC
            if (sectionSelected == 0) {
                vc?.item = freshItems[rowSelected!]
            } else {
                vc?.item = frozenItems[rowSelected!]
            }
            vc?.section = sectionSelected!
            vc?.row = rowSelected!
        }
    }
    
    // change the title name
    @IBAction func changeTitleName(_ sender: Any) {
        var textField = UITextField()
           
        let alert = UIAlertController(title: "更改标题", message: "请输入新标题", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "新标题"
            textField = alertTextField
        }
           
        let action_1 = UIAlertAction(title: "确定", style: .default) { (action_1) in
            self.titleName.text! = textField.text!
            self.defaultsDB.set(self.titleName.text!, forKey: "TitleName")
        }
           
        let action_2 = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        alert.addAction(action_1)
        alert.addAction(action_2)
        
        present(alert, animated: true)
    }
    
    // save and load items to CoreData
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving")
        }
        freshItems.sort(by: { $0.daysLeft < $1.daysLeft})
        frozenItems.sort(by: { $0.daysLeft < $1.daysLeft})
        freshTable.reloadData()
        frozenTable.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            loadedItems = try context.fetch(request)
        } catch {
            print("Error loading")
        }

        self.freshItems = []
        self.frozenItems = []
        
        for t in loadedItems {
            if (t.ifFresh) {
                freshItems.append(t)
            } else {
                frozenItems.append(t)
            }
        }
        
        freshItems.sort(by: { $0.daysLeft < $1.daysLeft})
        frozenItems.sort(by: { $0.daysLeft < $1.daysLeft})
    }
    
    // other helper functions
    
    // update the days left
    func updateDaysLeft() {
        for item in freshItems {
            item.daysLeft = compute(expDate: item.expDate!)
        }
        for item in frozenItems {
            item.daysLeft = compute(expDate: item.expDate!)
        }
        saveItems()
    }
    
    // compute the days left
    func compute(expDate: String) -> Int64 {
        let date = Date()
        let calendar = Calendar.current
        let cur = calendar.dateComponents([.year, .month, .day], from: date)
        let s = expDate.split(separator: "-")
        let dateComp = DateComponents(year: Int(s[0]), month: Int(s[1]), day: Int(s[2]))
        
        return Int64(Calendar.current.dateComponents([.day], from: cur, to: dateComp).day!)
    }
    
    // update notification center
    func updateNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        if (freshItems.count == 0 && frozenItems.count == 0) {
            return
        } else {
            let index1 = getfood(foodList: freshItems)
            let index2 = getfood(foodList: frozenItems)
            
            if (index1 >= 0 && index2 >= 0) {
                if (freshItems[index1].daysLeft < frozenItems[index2].daysLeft) {
                    NotificationManager.instance.scheduleNotification(s: freshItems[index1].itemName!, startDate: computeStartDate(expDate: freshItems[index1].expDate!, i: 0), times: Int(self.setDays!)!)
                } else {
                    NotificationManager.instance.scheduleNotification(s: frozenItems[index2].itemName!, startDate: computeStartDate(expDate: frozenItems[index2].expDate!, i: 1), times: Int(self.setDays!)!)
                }
            } else {
                if (index1 >= 0) {
                    NotificationManager.instance.scheduleNotification(s: freshItems[index1].itemName!, startDate: computeStartDate(expDate: freshItems[index1].expDate!, i: 0), times: Int(self.setDays!)!)
                } else if (index2 >= 0){
                    NotificationManager.instance.scheduleNotification(s: frozenItems[index2].itemName!, startDate: computeStartDate(expDate: frozenItems[index2].expDate!, i: 1), times: Int(self.setDays!)!)
                }
            }
        }
    }
    
    // get the closest food that not expired yet
    func getfood(foodList: [Item]) -> Int {
        if (foodList.count == 0) {
            return -1
        }
        for i in 0...foodList.count - 1 {
            if (foodList[i].daysLeft < 0) {
                continue
            } else {
                return i
            }
        }
        return -1
    }
    
    // compute start date to send notification
    func computeStartDate(expDate: String, i: Int) -> Date {
        let s = expDate.split(separator: "-")
        
        var dateComp = DateComponents(year: Int(s[0]), month: Int(s[1]), day: Int(s[2]))
        dateComp.hour = Int(self.h!)
        dateComp.minute = Int(self.m!)
        var date = Calendar.current.date(from: dateComp)!
        if (i == 0) {
            date = Calendar.current.date(byAdding: .day, value: -Int(freshItems[0].daysLeft), to: date)!
        } else {
            date = Calendar.current.date(byAdding: .day, value: -Int(frozenItems[0].daysLeft), to: date)!
        }
        
        return date
    }
    
    
    // observe functions
    @objc func add(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let name = dict["name"] as? String, let date = dict["date"] as? String, let section = dict["section"] as? String, let num = dict["num"] as? String, let c = dict["category"] as? String, let com = dict["comment"] as? String, let protein = dict["protein"] as? String, let fat = dict["fat"] as? String, let vc = dict["vc"] as? String, let carbo = dict["carbo"] as? String, let cal = dict["cal"] as? String, let brief = dict["brief"] as? String {
                if section == "0" {
                    let newItem = Item(context: self.context)
                    newItem.itemName = name
                    newItem.expDate = date
                    newItem.daysLeft = compute(expDate: date)
                    newItem.ifFresh = true
                    newItem.num = Int64(num)!
                    newItem.category = Int64(c)!
                    newItem.com = com
                    
                    if protein != "-1" {
                        newItem.protein = Double(protein)!
                        newItem.fat = Double(fat)!
                        newItem.vc = Double(vc)!
                        newItem.carbo = Double(carbo)!
                        newItem.cal = Double(cal)!
                        newItem.brief = brief
                    } else {
                        newItem.protein = -1
                        newItem.fat = -1
                        newItem.vc = -1
                        newItem.carbo = -1
                        newItem.cal = -1
                        newItem.brief = "-1"
                    }
                    
                    freshItems.append(newItem)
                } else {
                    let newItem = Item(context: self.context)
                    newItem.itemName = name
                    newItem.expDate = date
                    newItem.daysLeft = compute(expDate: date)
                    newItem.ifFresh = false
                    newItem.num = Int64(num)!
                    newItem.category = Int64(c)!
                    newItem.com = com
                    
                    if protein != "-1" {
                        newItem.protein = Double(protein)!
                        newItem.fat = Double(fat)!
                        newItem.vc = Double(vc)!
                        newItem.carbo = Double(carbo)!
                        newItem.cal = Double(cal)!
                        newItem.brief = brief
                    } else {
                        newItem.protein = -1
                        newItem.fat = -1
                        newItem.vc = -1
                        newItem.carbo = -1
                        newItem.cal = -1
                        newItem.brief = "-1"
                    }
                    frozenItems.append(newItem)
                }
            }
        }
       
        self.updateAll()
        NotificationCenter.default.post(name: Notification.Name("com.rUpdate"), object: nil, userInfo: nil)
    }
    
    @objc func modifyDaySetting(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let num = dict["num"] as? String {
                self.setDays = num
            }
        }
        defaultsDB.set(self.setDays, forKey: "SetDays")
        updateDaysLeft()
        freshTable.reloadData()
        frozenTable.reloadData()
        updateNotifications()
        NotificationCenter.default.post(name: Notification.Name("com.update"), object: nil, userInfo: nil)
    }
    
    @objc func modifyTime(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let h = dict["h"] as? String, let m = dict["m"] as? String {
                self.h = h
                self.m = m
            }
        }
        defaultsDB.set(self.h, forKey: "FRHour")
        defaultsDB.set(self.m, forKey: "FRMinute")
        updateNotifications()
    }
    
    @objc func modify(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let name = dict["name"] as? String, let date = dict["date"] as? String, let section = dict["section"] as? String, let old_s = dict["old_section"] as? String, let old_r = dict["old_row"] as? String, let num = dict["num"] as? String, let com = dict["comment"] as? String, let ca = dict["c"] as? String, let protein = dict["protein"] as? String, let fat = dict["fat"] as? String, let vc = dict["vc"] as? String, let carbo = dict["carbo"] as? String, let cal = dict["cal"] as? String, let brief = dict["brief"] as? String {
                // remove old item
                if (old_s == "0") {
                    context.delete(freshItems[Int(old_r)!])
                    freshItems.remove(at: Int(old_r)!)
                } else {
                    context.delete(frozenItems[Int(old_r)!])
                    frozenItems.remove(at: Int(old_r)!)
                }
                // add new item
                if section == "0" {
                    let newItem = Item(context: self.context)
                    newItem.itemName = name
                    newItem.expDate = date
                    newItem.daysLeft = compute(expDate: date)
                    newItem.ifFresh = true
                    newItem.num = Int64(num)!
                    newItem.category = Int64(ca)!
                    newItem.com = com
                    if protein != "-1" {
                        newItem.protein = Double(protein)!
                        newItem.fat = Double(fat)!
                        newItem.vc = Double(vc)!
                        newItem.carbo = Double(carbo)!
                        newItem.cal = Double(cal)!
                        newItem.brief = brief
                    } else {
                        newItem.protein = -1
                        newItem.fat = -1
                        newItem.vc = -1
                        newItem.carbo = -1
                        newItem.cal = -1
                        newItem.brief = "-1"
                    }
                    freshItems.append(newItem)
                } else {
                    let newItem = Item(context: self.context)
                    newItem.itemName = name
                    newItem.expDate = date
                    newItem.daysLeft = compute(expDate: date)
                    newItem.ifFresh = false
                    newItem.num = Int64(num)!
                    newItem.category = Int64(ca)!
                    newItem.com = com
                    if protein != "-1" {
                        newItem.protein = Double(protein)!
                        newItem.fat = Double(fat)!
                        newItem.vc = Double(vc)!
                        newItem.carbo = Double(carbo)!
                        newItem.cal = Double(cal)!
                        newItem.brief = brief
                    } else {
                        newItem.protein = -1
                        newItem.fat = -1
                        newItem.vc = -1
                        newItem.carbo = -1
                        newItem.cal = -1
                        newItem.brief = "-1"
                    }
                    frozenItems.append(newItem)
                }
            }
        }
        
        updateAll()
    }
    
    @objc func modifyTheme(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let theme = dict["theme"] as? Int {
                if (theme == 0) {
                    self.overrideUserInterfaceStyle = .light
                } else {
                    self.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
    
    // Swipe Table Cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if (orientation == .right) {
            var textField = UITextField()
               
            let alert = UIAlertController(title: "使用", message: "", preferredStyle: .alert)
            
            var num = 1
            if (tableView == self.freshTable) {
                num = Int(self.freshItems[indexPath.row].num)
            } else {
                num = Int(self.frozenItems[indexPath.row].num)
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "使用数量:(1～\(num))"
                textField = alertTextField
            }
               
            let action_1 = UIAlertAction(title: "确定", style: .default) { (action_1) in
                if (textField.text!.isEmpty || !(textField.text?.isNumber)!) {
                    let alert2 = UIAlertController(title: "", message: "请输入数字谢谢！", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alert2.addAction(action)
                    self.present(alert2, animated: true)
                } else if (Int(textField.text!)! <= 0 || Int(textField.text!)! > num){
                    let alert2 = UIAlertController(title: "", message: "请输入在范围内的数字谢谢！", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alert2.addAction(action)
                    self.present(alert2, animated: true)
                } else {
                    let num_used = Int(textField.text!)!
                    let num_new = num - num_used
                    if (num_new > 0) {
                        if (tableView == self.freshTable) {
                            self.freshItems[indexPath.row].num = Int64(num_new)
                        } else {
                            self.frozenItems[indexPath.row].num = Int64(num_new)
                        }
                    } else {
                        if (tableView == self.freshTable) {
                            self.context.delete(self.freshItems[indexPath.row])
                            self.freshItems.remove(at: indexPath.row)
                        } else {
                            self.context.delete(self.frozenItems[indexPath.row])
                            self.frozenItems.remove(at: indexPath.row)
                        }
                    }
                    
                    self.updateAll()
                    NotificationCenter.default.post(name: Notification.Name("com.rUpdate"), object: nil, userInfo: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
               
            let action_2 = UIAlertAction(title: "取消", style: .default, handler: nil)
            
            alert.addAction(action_1)
            alert.addAction(action_2)
            
            let useAction = SwipeAction(style: .destructive, title: "使用") { action, indexPath in
                self.present(alert, animated: true)
            }
            
            useAction.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
            useAction.textColor = .systemGreen
            return [useAction]
            
        } else {
            let alert = UIAlertController(title: "移除", message: "请问确定要移除该食品记录吗?", preferredStyle: .alert)
            
            let action_1 = UIAlertAction(title: "确定", style: .default) { (action_1) in
                if (tableView == self.freshTable) {
                    self.context.delete(self.freshItems[indexPath.row])
                    self.freshItems.remove(at: indexPath.row)
                } else {
                    self.context.delete(self.frozenItems[indexPath.row])
                    self.frozenItems.remove(at: indexPath.row)
                }
                
                self.updateAll()
                NotificationCenter.default.post(name: Notification.Name("com.rUpdate"), object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
            }
            
            let action_2 = UIAlertAction(title: "我再想想", style: .default, handler: nil)
            
            alert.addAction(action_1)
            alert.addAction(action_2)
            
            let deleteAction = SwipeAction(style: .destructive, title: "移除") { action, indexPath in
                self.present(alert, animated: true)
            }
            
            deleteAction.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
            deleteAction.textColor = .red
            return [deleteAction]
        }
    }
    
    // refactored function
    func updateAll() {
        saveItems()
        loadItems()
        updateDaysLeft()
        updateNotifications()
        NotificationCenter.default.post(name: Notification.Name("com.update"), object: nil, userInfo: nil)
    }
}

extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}
