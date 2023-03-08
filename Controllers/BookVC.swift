import UIKit
import SQLite3
import Firebase
import CoreData

class BookVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // reference var
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var selectedWay: UISegmentedControl!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchLogo: UIButton!
    @IBOutlet weak var nonLabel: UILabel!
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var nonLabel2: UILabel!
    @IBOutlet weak var collectTable: UITableView!
    @IBOutlet weak var rTable: UITableView!
    @IBOutlet weak var nonLabel3: UILabel!
    
    @IBOutlet weak var w1: NSLayoutConstraint!
    @IBOutlet weak var w2: NSLayoutConstraint!
    
    // other var
    var searchResults : [recipeInfo] = []
    var rowSelected = 0
    var collectResults : [recipeInfo] = []
    var rResults : [recipeInfo] = []
    let db = Firestore.firestore()
    var sectionIn = 0
    var loadedItems : [Item] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.view.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.22, green: 0.39, blue: 0.73, alpha: 1.0))
        self.selectedWay.selectedSegmentIndex = 0
        self.searchLogo.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.searchBar.placeholder = "想学什么～"
        self.searchBar.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.searchBar.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.searchBar.layer.cornerRadius = 25
        self.searchBar.layer.masksToBounds = true
        
        // table
        self.searchTable.delegate = self
        self.searchTable.dataSource = self
        self.searchTable.register(UITableViewCell.self,
                               forCellReuseIdentifier: "SearchCell")
        self.searchTable.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.collectTable.delegate = self
        self.collectTable.dataSource = self
        self.collectTable.register(UITableViewCell.self,
                               forCellReuseIdentifier: "CollectCell")
        self.collectTable.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.collectTable.layer.cornerRadius = 10
        self.collectTable.rowHeight = 60
        
        self.rTable.delegate = self
        self.rTable.dataSource = self
        self.rTable.register(UITableViewCell.self,
                               forCellReuseIdentifier: "RCell")
        self.rTable.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.rTable.layer.cornerRadius = 10
        self.rTable.rowHeight = 60
        
        // view color
        self.bigView.layer.cornerRadius = 10
        self.bigView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.firstView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.secondView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.thirdView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        // title color
        self.titleLabel.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        // set constraints
        self.w1.constant = self.bigView.frame.width * 0.8
        self.w2.constant = self.view.frame.width * 0.6
        
        if (self.selectedWay.selectedSegmentIndex == 0) {
            self.firstView.isHidden = false
            self.secondView.isHidden = true
            self.thirdView.isHidden = true
        } else if (self.selectedWay.selectedSegmentIndex == 1) {
            self.firstView.isHidden = true
            self.secondView.isHidden = false
            self.thirdView.isHidden = true
        } else {
            self.firstView.isHidden = true
            self.secondView.isHidden = true
            self.thirdView.isHidden = false
        }
        
        // load
        if Auth.auth().currentUser != nil {
            loadCollecting()
        } else {
            checkCollecting()
        }
        
        rAnalyze()
        checkR()
        
        self.nonLabel.isHidden = true
        self.nonLabel.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.nonLabel.font = UIFont.boldSystemFont(ofSize: 17)

        self.nonLabel2.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.nonLabel2.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.nonLabel3.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.nonLabel3.font = UIFont.boldSystemFont(ofSize: 17)
        
        // Observe
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollecting(_:)), name: Notification.Name("com.updateCollecting"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logOut(_:)), name: Notification.Name("com.logOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logIn(_:)), name: Notification.Name("com.logIn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rUpdate(_:)), name: Notification.Name("com.rUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modifyTheme(_:)), name: Notification.Name("com.theme"), object: nil)
    }
    
    func loadCollecting() {
        db.collection((Auth.auth().currentUser?.phoneNumber!)! + "R").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.searchSingle(Id: Int32(document.documentID)!)
                }
                self.checkCollecting()
            }
        }
    }
    
    func searchSingle(Id : Int32) {
        var databasePointer = RecipeDB.instance.getDBP()
        var statement : OpaquePointer?
        
        if sqlite3_prepare_v2(databasePointer, "select * from caipu where id == \(Id);", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
            print("error preparing select: \(errmsg)")
        }

        if sqlite3_step(statement) == SQLITE_ROW {
            var time = "暂无相关信息"
            var people = "暂无相关信息"
            var intro = "暂无相关信息"
            var tip = "暂无相关信息"
            
            if sqlite3_column_text(statement, 6) != nil {
                time = String(cString: sqlite3_column_text(statement, 6))
            }
            if sqlite3_column_text(statement, 8) != nil {
                people = String(cString: sqlite3_column_text(statement, 8))
            }
            if sqlite3_column_text(statement, 10) != nil {
                intro = String(cString: sqlite3_column_text(statement, 10))
            }
            if sqlite3_column_text(statement, 11) != nil {
                tip = String(cString: sqlite3_column_text(statement, 11))
            }
            
            let newRecipe = recipeInfo(Id: Int(sqlite3_column_int(statement, 0)), title: String(cString: sqlite3_column_text(statement, 2)), time: time, people: people, intro: intro, tip: tip)
                                     
            collectResults.append(newRecipe)
        }

        
        sqlite3_close(databasePointer)
        databasePointer = nil
    }
    
    func rAnalyze() {
        loadItems()
        rResults = []
        
        var databasePointer = RecipeDB.instance.getDBP()
        var statement : OpaquePointer?
        
        var indexList : [Int] = []
        
        for t in loadedItems {
            let s = "'%\(t.itemName!)%'"
            
            if sqlite3_prepare_v2(databasePointer, "select id from shicai where key like \(s);", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
                print("error preparing select: \(errmsg)")
            }
            
            if sqlite3_step(statement) == SQLITE_ROW {
                indexList.append(Int(sqlite3_column_int(statement, 0)))
            }
        }
        
        var indexList2 : [Int] = []
        
        for i in indexList {
        
            if sqlite3_prepare_v2(databasePointer, "select caipu_id from caipu_x_shicai where shicai_id like \(i);", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
                print("error preparing select: \(errmsg)")
            }
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let Id = Int(sqlite3_column_int(statement, 0))
                if !indexList2.contains(Id) {
                    indexList2.append(Int(sqlite3_column_int(statement, 0)))
                }
            }
        }
        
        for i in indexList2 {
            
            if sqlite3_prepare_v2(databasePointer, "select * from caipu where id == \(i);", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
                print("error preparing select: \(errmsg)")
            }

            if sqlite3_step(statement) == SQLITE_ROW {
                var time = "暂无相关信息"
                var people = "暂无相关信息"
                var intro = "暂无相关信息"
                var tip = "暂无相关信息"
                
                if sqlite3_column_text(statement, 6) != nil {
                    time = String(cString: sqlite3_column_text(statement, 6))
                }
                if sqlite3_column_text(statement, 8) != nil {
                    people = String(cString: sqlite3_column_text(statement, 8))
                }
                if sqlite3_column_text(statement, 10) != nil {
                    intro = String(cString: sqlite3_column_text(statement, 10))
                }
                if sqlite3_column_text(statement, 11) != nil {
                    tip = String(cString: sqlite3_column_text(statement, 11))
                }
                
                let newRecipe = recipeInfo(Id: Int(sqlite3_column_int(statement, 0)), title: String(cString: sqlite3_column_text(statement, 2)), time: time, people: people, intro: intro, tip: tip)
                                         
                rResults.append(newRecipe)
            }
        }
        
        sqlite3_close(databasePointer)
        databasePointer = nil
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            loadedItems = try context.fetch(request)
        } catch {
            print("Error loading")
        }
    }
    
    func checkR() {
        self.rTable.reloadData()
        
        if self.rResults.count == 0 {
            self.nonLabel3.isHidden = false
            self.rTable.isHidden = true
        } else {
            self.nonLabel3.isHidden = true
            self.rTable.isHidden = false
        }
    }
    
    func checkCollecting() {
        self.collectTable.reloadData()
        
        if self.collectResults.count == 0 {
            self.nonLabel2.isHidden = false
            self.collectTable.isHidden = true
        } else {
            self.nonLabel2.isHidden = true
            self.collectTable.isHidden = false
        }
    }
    
    @IBAction func selectedChange(_ sender: Any) {
        if (self.selectedWay.selectedSegmentIndex == 0) {
            self.firstView.isHidden = false
            self.secondView.isHidden = true
            self.thirdView.isHidden = true
        } else if (self.selectedWay.selectedSegmentIndex == 1) {
            self.firstView.isHidden = true
            self.nonLabel.isHidden = true
            self.secondView.isHidden = false
            self.thirdView.isHidden = true
        } else {
            self.firstView.isHidden = true
            self.nonLabel.isHidden = true
            self.secondView.isHidden = true
            self.thirdView.isHidden = false
        }
    }
    
    // table functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTable {
            return searchResults.count
        } else if tableView == collectTable {
            return collectResults.count
        } else {
            return rResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
            cell.textLabel!.text = self.searchResults[indexPath.row].title
            cell.layer.cornerRadius = 10
            cell.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
            cell.textLabel?.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0)).cgColor
            cell.textLabel?.textAlignment = .center
            cell.textLabel!.font = UIFont.systemFont(ofSize: 25)
            cell.selectionStyle = .none
            
            return cell
        } else if tableView == collectTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectCell", for: indexPath)
            cell.textLabel!.text = self.collectResults[indexPath.row].title
            cell.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
            cell.textLabel!.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
            cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 18)
            cell.layer.cornerRadius = 25
            cell.layer.borderWidth = 1
            cell.textLabel!.textAlignment = .center
            cell.layer.borderColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0)).cgColor
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RCell", for: indexPath)
            cell.textLabel!.text = self.rResults[indexPath.row].title
            cell.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
            cell.textLabel!.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
            cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 18)
            cell.layer.cornerRadius = 25
            cell.layer.borderWidth = 1
            cell.textLabel!.textAlignment = .center
            cell.layer.borderColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0)).cgColor
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTable {
            self.rowSelected = indexPath.row
            self.sectionIn = 0
            performSegue(withIdentifier: "recipe", sender: self)
        } else if tableView == collectTable {
            self.rowSelected = indexPath.row
            self.sectionIn = 1
            performSegue(withIdentifier: "recipe", sender: self)
        } else {
            self.rowSelected = indexPath.row
            self.sectionIn = 2
            performSegue(withIdentifier: "recipe", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipe" {
            let vc = segue.destination as? RecipeVC
            if sectionIn == 0 {
                vc?.recipeInfo = self.searchResults[self.rowSelected]
            } else if sectionIn == 1{
                vc?.recipeInfo = self.collectResults[self.rowSelected]
            } else {
                vc?.recipeInfo = self.rResults[self.rowSelected]
            }
        }
    }
    
    @IBAction func searchRecipe(_ sender: Any) {
        self.searchResults = []
        
        if searchBar.text != "" {
            var databasePointer = RecipeDB.instance.getDBP()
            var statement : OpaquePointer?
            
            let s = "'%\(searchBar.text!)%'"
            if sqlite3_prepare_v2(databasePointer, "select * from caipu where title like \(s);", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
                print("error preparing select: \(errmsg)")
            }

            while sqlite3_step(statement) == SQLITE_ROW {
                var time = "暂无相关信息"
                var people = "暂无相关信息"
                var intro = "暂无相关信息"
                var tip = "暂无相关信息"
                
                if sqlite3_column_text(statement, 6) != nil {
                    time = String(cString: sqlite3_column_text(statement, 6))
                }
                if sqlite3_column_text(statement, 8) != nil {
                    people = String(cString: sqlite3_column_text(statement, 8))
                }
                if sqlite3_column_text(statement, 10) != nil {
                    intro = String(cString: sqlite3_column_text(statement, 10))
                }
                if sqlite3_column_text(statement, 11) != nil {
                    tip = String(cString: sqlite3_column_text(statement, 11))
                }
                
                let newRecipe = recipeInfo(Id: Int(sqlite3_column_int(statement, 0)), title: String(cString: sqlite3_column_text(statement, 2)), time: time, people: people, intro: intro, tip: tip)
                                         
                searchResults.append(newRecipe)
            }
            
            self.searchTable.reloadData()
            
            sqlite3_close(databasePointer)
            databasePointer = nil
        }
        
        if self.searchResults.count == 0 {
            self.nonLabel.isHidden = false
            self.searchTable.reloadData()
        } else {
            self.nonLabel.isHidden = true
            self.searchTable.reloadData()
        }
    }
    
    // Observe functions
    @objc func updateCollecting(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let Id = dict["id"] as? String, let de = dict["delete"] as? String {
                if de == "1" {
                    var count = 0
                    for t in self.collectResults {
                        if t.Id == Int(Id) {
                            self.collectResults.remove(at: count)
                        }
                        count += 1
                    }
                } else {
                    searchSingle(Id: Int32(Id)!)
                }
            }
        }

        checkCollecting()
    }
    
    @objc func logOut(_ notification: NSNotification) {
        self.collectResults = []
        checkCollecting()
    }
    
    @objc func logIn(_ notification: NSNotification) {
        loadCollecting()
    }
    
    @objc func rUpdate(_ notification: NSNotification) {
        rAnalyze()
        checkR()
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
        searchTable.reloadData()
        collectTable.reloadData()
        rTable.reloadData()
    }
}
