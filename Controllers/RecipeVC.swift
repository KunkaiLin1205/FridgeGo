import UIKit
import SQLite3
import Firebase

class RecipeVC: UIViewController {
    
    // reference var
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var textView4: UITextView!
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    
    @IBOutlet weak var w1: NSLayoutConstraint!
    @IBOutlet weak var h3: NSLayoutConstraint!
    
    // other var
    var recipeInfo : recipeInfo?
    var searchResults : [String] = []
    var ifCollected = 0
    let db = Firestore.firestore()
    let defaultsDB = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tempTheme = defaultsDB.string(forKey: "FGTheme") {
            if (tempTheme == "light") {
                self.overrideUserInterfaceStyle = .light
            } else {
                self.overrideUserInterfaceStyle = .dark
            }
        } else {
            self.overrideUserInterfaceStyle = .light
        }
        
        self.view.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.textView3.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.textView4.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        
        self.l1.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l2.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.textView3.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.textView3.font = UIFont.systemFont(ofSize: 22)
        self.textView4.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.textView4.font = UIFont.systemFont(ofSize: 22)
        
        // load
        self.titleName.text = self.recipeInfo?.title
        self.titleName.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.titleName.textAlignment = .center
        self.star.tintColor =  UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        
        if Auth.auth().currentUser != nil {
            let docRef = db.collection((Auth.auth().currentUser?.phoneNumber!)! + "R").document(String(self.recipeInfo!.Id))

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    let image = UIImage(systemName: "star.fill")
                    self.star.setImage(image, for: .normal)
                    self.ifCollected = 1
                } else {
                    let image = UIImage(systemName: "star")
                    self.star.setImage(image, for: .normal)
                    self.ifCollected = 0
                }
            }
        } else {
            let image = UIImage(systemName: "star")
            star.setImage(image, for: .normal)
            self.ifCollected = 0
        }
        
        // set constraints
        self.w1.constant = self.view.frame.width * 0.6
        self.h3.constant = self.view.frame.height / 6.5
        
        searchIngredients()
        searchSteps()
    }
    
    func searchSteps() {
        self.searchResults = []
        
        var databasePointer = RecipeDB.instance.getDBP()
        var statement : OpaquePointer?
        
        var indexList : [Int] = []
        
        if sqlite3_prepare_v2(databasePointer, "select buzhou_id from caipu_x_buzhou where caipu_id == \(self.recipeInfo!.Id) order by buzhou_id;", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
            print("error preparing select: \(errmsg)")
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            indexList.append(Int(sqlite3_column_int(statement, 0)))
        }
        
        for i in indexList {
            if sqlite3_prepare_v2(databasePointer, "select value from buzhou where id == \(Int32(i));", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
                print("error preparing select: \(errmsg)")
            }
            
            if sqlite3_step(statement) == SQLITE_ROW {
                self.searchResults.append(String(cString: sqlite3_column_text(statement, 0)))
            }
        }
        
        var res = ""
        let num = self.searchResults.count
        var count = 1
        for s in self.searchResults {
            res += "-步骤 " + String(count) + "/\(num) \n"
            res += s
            res += "\n"
            count += 1
        }
        
        self.textView3.text = res
        
        sqlite3_close(databasePointer)
        databasePointer = nil
    }
    
    func searchIngredients() {
        self.searchResults = []
        
        var databasePointer = RecipeDB.instance.getDBP()
        var statement : OpaquePointer?
        
        var indexList : [Int] = []
        
        if sqlite3_prepare_v2(databasePointer, "select shicai_id from caipu_x_shicai where caipu_id == \(self.recipeInfo!.Id) order by shicai_id;", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
            print("error preparing select: \(errmsg)")
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            indexList.append(Int(sqlite3_column_int(statement, 0)))
        }
        
        for i in indexList {
            if sqlite3_prepare_v2(databasePointer, "select key, value from shicai where id == \(Int32(i));", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
                print("error preparing select: \(errmsg)")
            }
            
            if sqlite3_step(statement) == SQLITE_ROW {
                self.searchResults.append(String(cString: sqlite3_column_text(statement, 0)))
                self.searchResults.append(String(cString: sqlite3_column_text(statement, 1)))
                
            }
        }
        
        var res = ""
        var count = 1
        var count2 = 2
        for s in self.searchResults {
            if count2 % 2 == 0 {
                res += String(count) + "."
                count += 1
            }
            res += s
            res += "  "
            count2 += 1
        }
        
        self.textView4.text = res
    }
    
    @IBAction func collect(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            let alert = UIAlertController(title: "无用户登录", message: "请登录用户", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        if self.ifCollected == 0 {
            self.ifCollected = 1
            let image = UIImage(systemName: "star.fill")
            star.setImage(image, for: .normal)
            db.collection((Auth.auth().currentUser?.phoneNumber!)! + "R").document(String(self.recipeInfo!.Id)).setData(["ifCollected" : true])
            var info = [String: String]()
            info["id"] = String(self.recipeInfo!.Id)
            info["delete"] = "0"
            NotificationCenter.default.post(name: Notification.Name("com.updateCollecting"), object: nil, userInfo: info)
        } else {
            self.ifCollected = 0
            let image = UIImage(systemName: "star")
            star.setImage(image, for: .normal)
            db.collection((Auth.auth().currentUser?.phoneNumber!)! + "R").document(String(self.recipeInfo!.Id)).delete()
            var info = [String: String]()
            info["id"] = String(self.recipeInfo!.Id)
            info["delete"] = "1"
            NotificationCenter.default.post(name: Notification.Name("com.updateCollecting"), object: nil, userInfo: info)
        }
    }
}
