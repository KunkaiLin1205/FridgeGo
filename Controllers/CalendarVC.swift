import UIKit
import FSCalendar
import CoreData

class CalendarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // reference var
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var itemTable: UITableView!
    @IBOutlet weak var calView: FSCalendar!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    
    @IBOutlet weak var c1: NSLayoutConstraint!
    
    // other var
    var setDays : Int?
    let defaultsDB = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var loadedItems: [Item] = []
    var selectedItems: [Item] = []
    var expDates: [Date : [Item]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateLabel.text = "日期未选定"
        
        // set table and calendar view and load set days
        self.itemTable.delegate = self
        self.itemTable.dataSource = self
        self.itemTable.register(UINib(nibName: "CustomizedCell", bundle: nil),
                           forCellReuseIdentifier: "Cell")
        
        self.itemTable.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
        self.calView.layer.cornerRadius = 10.0
        self.itemTable.layer.cornerRadius = 10.0
        
        if let tempSetDays = defaultsDB.string(forKey: "SetDays") {
            setDays = Int(tempSetDays)
        } else {
            setDays = 3
        }
        
        self.calView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
        self.calView.appearance.headerTitleColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.calView.appearance.weekdayTextColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.view.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.22, green: 0.39, blue: 0.73, alpha: 1.0))
        // view color
        self.bigView.layer.cornerRadius = 10
        self.bigView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        // title color
        self.titleLabel.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.dateLabel.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.dateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        l1.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        l2.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        l3.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        
        c1.constant =  self.view.frame.width / 6
        
        loadItems()
        computeExpInfo()
        
        //Observe
        NotificationCenter.default.addObserver(self, selector: #selector(update(_:)), name: Notification.Name("com.update"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modifyTheme(_:)), name: Notification.Name("com.theme"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = selectedItems[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomizedCell {
            switch temp.category {
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
            
            cell.foodName.text = temp.itemName
            cell.num.text = String(temp.num)
            
            let s = temp.expDate!.split(separator: "-")
            cell.timeLeft.text = s[1] + "/" + s[2]
            
            cell.category.font = UIFont.boldSystemFont(ofSize: 17)
            cell.foodName.font = UIFont.boldSystemFont(ofSize: 17)
            cell.num.font = UIFont.boldSystemFont(ofSize: 17)
            cell.timeLeft.font = UIFont.boldSystemFont(ofSize: 17)
            
            cell.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
            cell.category.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
            cell.foodName.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
            cell.num.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
            cell.timeLeft.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
            
            cell.layer.cornerRadius = 25
            return cell
        }
        
        return UITableViewCell()
    }
    
    // helper functions
    func computeExpInfo() {
        for t in loadedItems {
            let expDate = t.expDate!
            let s = expDate.split(separator: "-")
            let dateComp = DateComponents(year: Int(s[0]), month: Int(s[1]), day: Int(s[2]))
            var date = Calendar.current.date(from: dateComp)!
            // add the expected date
            if expDates[date] == nil {
                expDates[date] = []
            }
            expDates[date]!.append(t)
            // add all dates in setDays range
            for _ in 1...setDays! {
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                if expDates[date] == nil {
                    expDates[date] = []
                }
                expDates[date]!.append(t)
            }
        }
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            loadedItems = try context.fetch(request)
        } catch {
            print("Error loading")
        }
        
        loadedItems.sort(by: { $0.daysLeft < $1.daysLeft})
    }
    
    func compareDate(d1: Date, d2: Date) -> Bool {
        let comp1 = Calendar.current.dateComponents([.year, .month, .day], from: d1)
        let comp2 = Calendar.current.dateComponents([.year, .month, .day], from: d2)
        return comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day
    }
    
    @objc func update(_ notification: NSNotification) {
        loadedItems = []
        expDates = [:]
        if let tempSetDays = defaultsDB.string(forKey: "SetDays") {
            setDays = Int(tempSetDays)
        }
        loadItems()
        computeExpInfo()
        self.calView.reloadData()
        if calView.selectedDate != nil {
            selectedItems = []
            for k in expDates.keys {
                if compareDate(d1: k, d2: calView.selectedDate!) {
                    selectedItems = expDates[k]!
                    break
                }
            }
            itemTable.reloadData()
        }
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
    
}

extension CalendarVC: FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: date)
        let separate = strDate.split(separator: ",")
        self.dateLabel.text = String(separate[0])
        
        selectedItems = []
        for k in expDates.keys {
            if compareDate(d1: k, d2: date) {
                selectedItems = expDates[k]!
                break
            }
        }
        if selectedItems.count == 0 {

        } else {
            itemTable.backgroundView = nil
        }
        itemTable.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {

        for k in expDates.keys {
            if compareDate(d1: k, d2: date) {
                return UIColor(red: 0.866, green: 0.129, blue: 0, alpha: 1.0)
            }
        }
        
        return nil
    }
    
}

