import UIKit
import Firebase
import CoreData

class SettingVC: UIViewController {
    // reference var
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var bigTitle: UILabel!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var logLabel: UILabel!
    @IBOutlet weak var c1: NSLayoutConstraint!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var setDays: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var line5: UIView!
    @IBOutlet weak var dailyTime: UIDatePicker!
    @IBOutlet weak var uploadBut: UIButton!
    @IBOutlet weak var loadBut: UIButton!
    @IBOutlet weak var infoBut: UIButton!
    @IBOutlet weak var contactBut: UIButton!
    @IBOutlet weak var modeSwitcher: UISwitch!
    
    @IBOutlet weak var w1: NSLayoutConstraint!
    @IBOutlet weak var c2: NSLayoutConstraint!
    @IBOutlet weak var c3: NSLayoutConstraint!
    
    // other var
    let defaultsDB = UserDefaults.standard
    var loadedItems: [Item] = []
    let db = Firestore.firestore()
    // set context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.22, green: 0.39, blue: 0.73, alpha: 1.0))
        self.dailyTime.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        // load
        if let tempSetDays = defaultsDB.string(forKey: "SetDays") {
            setDays.text = tempSetDays
            stepper.value = Double(tempSetDays)!
        } else {
            setDays.text = "3"
            stepper.value = 3
        }
        
        if let tempTheme = defaultsDB.string(forKey: "FGTheme") {
            if (tempTheme == "light") {
                l4.text = "浅色模式"
                self.modeSwitcher.isOn = false
            } else {
                l4.text = "深色模式"
                self.modeSwitcher.isOn = true
            }
        } else {
            l4.text = "浅色模式"
            self.modeSwitcher.isOn = false
        }
        
        if Auth.auth().currentUser != nil {
            logButton.isHidden = true
            userButton.isHidden = false
            logLabel.isHidden = true
        } else {
            logButton.isHidden = false
            userButton.isHidden = true
            logLabel.text = "暂无用户登录"
            logLabel.isHidden = false
        }
        
        var dc = DateComponents()
        if let tempH = defaultsDB.string(forKey: "FRHour"), let tempM = defaultsDB.string(forKey: "FRMinute") {
            dc.hour = Int(tempH)
            dc.minute = Int(tempM)
        } else {
            dc.hour = 10
            dc.minute = 0
        }
        
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        dailyTime.date = gregorianCalendar.date(from: dc)!
        
        // view color
        self.bigView.layer.cornerRadius = 8
        self.bigView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.smallView.layer.cornerRadius = 8
        self.smallView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
        // title
        self.bigTitle.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.bigTitle.font = UIFont.boldSystemFont(ofSize: 20)
        // login button
        self.logButton.backgroundColor = UIColor.gray
        self.logButton.tintColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.logButton.layer.cornerRadius = 30
        self.userButton.backgroundColor = UIColor.gray
        self.userButton.tintColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.userButton.layer.cornerRadius = 30
        
        c1.constant = -self.view.frame.width / 6
        c2.constant = 0
        c3.constant = -self.modeSwitcher.fs_width / 2
        
        // login label
        self.logLabel.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.logLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        // label color
        self.l1.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l1.font = UIFont.boldSystemFont(ofSize: 17)
        self.l2.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l2.font = UIFont.boldSystemFont(ofSize: 17)
        self.l3.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l3.font = UIFont.boldSystemFont(ofSize: 17)
        self.l4.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l4.font = UIFont.boldSystemFont(ofSize: 17)
        self.uploadBut.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.infoBut.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.loadBut.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.contactBut.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.setDays.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.setDays.font = UIFont.boldSystemFont(ofSize: 17)
        self.stepper.layer.cornerRadius = 15
        self.line1.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.line2.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.line3.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.line4.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.line5.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        
        // set constraints
        self.w1.constant = self.bigView.frame.width / 3
        //Observe
        NotificationCenter.default.addObserver(self, selector: #selector(logIn(_:)), name: Notification.Name("com.login"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modifyTheme(_:)), name: Notification.Name("com.theme"), object: nil)
    }
    
    @IBAction func changeSetDays(_ sender: Any) {
        self.setDays.text = String(Int(self.stepper.value))
        var info = [String: String]()
        info["num"] = self.setDays.text!
        
        NotificationCenter.default.post(name: Notification.Name("com.modifyDS"), object: nil, userInfo: info)
    }
    
    @IBAction func changeDailyTime(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let strDate = dateFormatter.string(from: dailyTime.date)
        let s = strDate.split(separator: ":")
        let s2 = String(s[1]).split(separator: " ")
        var hour = Int(s[0])!
        if String(s2[1]) == "PM" {
            if hour != 12 {
                hour += 12
            }
        } else if (String(s2[1]) == "AM" && hour == 12) {
            hour = 0
        }
        
        var info = [String: String]()
        info["h"] = String(hour)
        info["m"] = String(s2[0])

        NotificationCenter.default.post(name: Notification.Name("com.modifyTime"), object: nil, userInfo: info)
    }
    
    @IBAction func login(_ sender: Any) {
        performSegue(withIdentifier: "log", sender: self)
    }
    
    
    @objc func logIn(_ notification: NSNotification) {
        if Auth.auth().currentUser != nil {
            logButton.isHidden = true
            userButton.isHidden = false
            logLabel.isHidden = true
        } else {
            logButton.isHidden = false
            userButton.isHidden = true
            logLabel.text = "暂无用户登录"
            logLabel.isHidden = false
        }
    }
    
    @IBAction func upload(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            let alert = UIAlertController(title: "无用户登录", message: "请登录用户", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "同步数据到云端", message: "是否确定同步", preferredStyle: .alert)
            
            let action_1 = UIAlertAction(title: "确定", style: .default) { (action_1) in
                self.uploadHelper()
            }
            
            let action_2 = UIAlertAction(title: "取消", style: .default, handler: nil)
            
            alert.addAction(action_1)
            alert.addAction(action_2)
            self.present(alert, animated: true)
        }
    }
    
    func uploadHelper() {
        loadItems()
        let newAddr = randomString(length: 16)
        let hisReference = db.collection((Auth.auth().currentUser?.phoneNumber!)!).document("History")

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let hisDocument: DocumentSnapshot
            do {
                try hisDocument = transaction.getDocument(hisReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldAddr = hisDocument.data()?["Addr"] as? String else {
                return nil
            }
            
            self.delete(collection: self.db.collection(oldAddr))

            transaction.updateData(["Addr": newAddr], forDocument: hisReference)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
        
        for t in self.loadedItems {
            self.db.collection(newAddr).addDocument(data: [
                "itemName": t.itemName!,
                "num": t.num,
                "ifFresh": t.ifFresh,
                "expDate": t.expDate!,
                "daysLeft": t.daysLeft,
                "protein": t.protein,
                "fat": t.fat,
                "vc": t.vc,
                "category": t.category,
                "carbo": t.carbo,
                "cal" : t.cal,
                "brief" : t.brief!,
                "com" : t.com!
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
    
    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    func delete(collection: CollectionReference, batchSize: Int = 1) {
        collection.limit(to: batchSize).getDocuments { (docset, error) in
          // An error occurred.
          let docset = docset

          let batch = collection.firestore.batch()
          docset?.documents.forEach { batch.deleteDocument($0.reference) }

          batch.commit {_ in
            self.delete(collection: collection, batchSize: batchSize)
          }
        }
      }
    
    @IBAction func load(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            let alert = UIAlertController(title: "无用户登录", message: "请登录用户", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "从云端读取数据", message: "是否确定读取覆盖本地数据", preferredStyle: .alert)
            
            let action_1 = UIAlertAction(title: "确定", style: .default) { (action_1) in
                self.loadHelper()
            }
            
            let action_2 = UIAlertAction(title: "取消", style: .default, handler: nil)
            
            alert.addAction(action_1)
            alert.addAction(action_2)
            self.present(alert, animated: true)
        }
    }
    
    func loadHelper() {
        
        let docRef = db.collection((Auth.auth().currentUser?.phoneNumber!)!).document("History")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let addr = (document.data()!["Addr"] as? String)!
                self.db.collection(addr).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if querySnapshot!.documents.count != 0 {
                            self.loadItems()
                            for t in self.loadedItems {
                                self.context.delete(t)
                            }
                        } else {
                            let alert = UIAlertController(title: "云端数据为空", message: "请同步后在下载", preferredStyle: .alert)
                            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true)
                            return
                        }
                        for document in querySnapshot!.documents {
                            var info = [String: String]()
                            info["name"] = document.data()["itemName"] as! String
                            info["date"] = document.data()["expDate"] as! String
                            if document.data()["ifFresh"] as! Bool {
                                info["section"] = "0"
                            } else {
                                info["section"] = "1"
                            }
                            info["num"] = String(document.data()["num"] as! Int)
                            info["category"] = String(document.data()["category"] as! Int)
                            info["comment"] = document.data()["com"] as! String
                            info["protein"] = String(document.data()["protein"] as! Double)
                            info["fat"] = String(document.data()["fat"] as! Double)
                            info["vc"] = String(document.data()["vc"] as! Double)
                            info["carbo"] = String(document.data()["carbo"] as! Double)
                            info["cal"] = String(document.data()["cal"] as! Double)
                            info["brief"] = document.data()["brief"] as! String
                            
                            NotificationCenter.default.post(name: Notification.Name("com.main"), object: nil, userInfo: info)
                        }
                        NotificationCenter.default.post(name: Notification.Name("com.rUpdate"), object: nil, userInfo: nil)
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func changeMode(_ sender: Any) {
        var info = [String: Int]()
        
        if (!self.modeSwitcher.isOn) {
            info["theme"] = 0
            self.overrideUserInterfaceStyle = .light
            defaultsDB.set("light", forKey: "FGTheme")
            self.l4.text = "浅色模式"
        } else {
            info["theme"] = 1
            self.overrideUserInterfaceStyle = .dark
            defaultsDB.set("dark", forKey: "FGTheme")
            self.l4.text = "深色模式"
        }
        NotificationCenter.default.post(name: Notification.Name("com.theme"), object: nil, userInfo: info)
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            loadedItems = try context.fetch(request)
        } catch {
            print("Error loading")
        }
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving")
        }
    }
    
    @IBAction func goInfo(_ sender: Any) {
        performSegue(withIdentifier: "info", sender: self)
    }
    
    @IBAction func goContact(_ sender: Any) {
        performSegue(withIdentifier: "contact", sender: self)
    }
    
    @IBAction func userPage(_ sender: Any) {
        performSegue(withIdentifier: "user", sender: self)
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

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}

extension UIColor {

   public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
      if #available(iOS 13.0, *) {
         return UIColor {
            switch $0.userInterfaceStyle {
            case .dark:
               return dark
            default:
               return light
            }
         }
      } else {
         return light
      }
   }
}
