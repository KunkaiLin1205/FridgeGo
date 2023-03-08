import UIKit
import SQLite3

class AddingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // reference var
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchLogo: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var nonLabel: UILabel!
    @IBOutlet weak var w1: NSLayoutConstraint!
    @IBOutlet weak var h: NSLayoutConstraint!
    
    // other var
    var wayToAdd = 0
    var categoryToAdd = 0
    var searchResults : [searchItem] = []
    var rowSelected : Int?
    var cellWidth : CGFloat = 0.0
    var tap : UITapGestureRecognizer?
    // set context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap!.cancelsTouchesInView = false
        view.addGestureRecognizer(tap!)
        
        self.view.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.22, green: 0.39, blue: 0.73, alpha: 1.0))
        
        self.categoryCollection.delegate = self
        self.categoryCollection.dataSource = self
        self.categoryCollection.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.cellWidth = (self.view.frame.width - 65) / 4
        self.h.constant = self.cellWidth * 2 + 5
        print(cellWidth)
        
        self.searchTable.delegate = self
        self.searchTable.dataSource = self
        self.searchTable.layer.cornerRadius = 10
        self.searchTable.register(UITableViewCell.self,
                               forCellReuseIdentifier: "SearchCell")
        self.searchTable.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.searchTable.rowHeight = 40

        // view color
        self.bigView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.bigView.layer.cornerRadius = 10
        // title color
        self.titleLabel.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.searchLogo.tintColor =  UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        
        self.searchBar.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.searchBar.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.searchBar.layer.cornerRadius = 15
        self.searchBar.layer.masksToBounds = true
        
        self.w1.constant = self.view.frame.width - 75
        
        self.nonLabel.isHidden = true
        self.nonLabel.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.nonLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        // observe
        NotificationCenter.default.addObserver(self, selector: #selector(modifyTheme(_:)), name: Notification.Name("com.theme"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishAdding(_:)), name: Notification.Name("com.finishadding"), object: nil)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CustomizedCollectionCell {
            switch indexPath.row {
            case 0:
                cell.imageView?.image = UIImage(named: "veg2")
                cell.label.text = "蔬菜"
            case 1:
                cell.imageView?.image = UIImage(named: "fruit2")
                cell.label.text = "水果"
            case 2:
                cell.imageView?.image = UIImage(named: "drink2")
                cell.label.text = "饮品"
            case 3:
                cell.imageView?.image = UIImage(named: "cream2")
                cell.label.text = "冷冻食品"
            case 4:
                cell.imageView?.image = UIImage(named: "egg2")
                cell.label.text = "蛋奶制品"
            case 5:
                cell.imageView?.image = UIImage(named: "seafood2")
                cell.label.text = "海鲜"
            case 6:
                cell.imageView?.image = UIImage(named: "meat2")
                cell.label.text = "肉类"
            default:
                cell.imageView?.image = UIImage(named: "others2")
                cell.label.text = "其他"
            }
            cell.layer.borderWidth = 2.0
            cell.label.textAlignment = .center
            cell.label.font = UIFont.boldSystemFont(ofSize: 12.5)
            cell.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
            cell.label.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0)).cgColor
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.categoryToAdd = indexPath.row
        performSegue(withIdentifier: "adding", sender: self)
    }
    
    // table functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        cell.textLabel!.text = self.searchResults[indexPath.row].itemName
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        cell.textLabel?.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0)).cgColor
        cell.textLabel?.textAlignment = .center
        cell.textLabel!.font = UIFont.systemFont(ofSize: 25)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.rowSelected = indexPath.row
        performSegue(withIdentifier: "search", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adding" {
            let vc = segue.destination as? AddingDetailVCViewController
            vc?.category = self.categoryToAdd
        }
        if segue.identifier == "search" {
            let vc = segue.destination as? AddingSearchViewController
            vc?.item = self.searchResults[self.rowSelected!]
        }
    }
    
    @IBAction func searchKeyWord(_ sender: Any) {
        self.searchResults = []
        
        if searchBar.text == "" {
            searchTable.isHidden = true
            nonLabel.isHidden = true
            return
        }
        
        if searchBar.text != "" {
            var databasePointer = IngredientDB.instance.getDBP()
            var statement : OpaquePointer?
            
            let s = "'%\(searchBar.text!)%'"
            if sqlite3_prepare_v2(databasePointer, "select * from Food where food_name like \(s);", -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(databasePointer)!)
                print("error preparing select: \(errmsg)")
            }

            while sqlite3_step(statement) == SQLITE_ROW {
                let newItem = searchItem(itemName: String(cString: sqlite3_column_text(statement, 1)), category: String(cString:sqlite3_column_text(statement, 0)), protein: sqlite3_column_double(statement, 2), fat: sqlite3_column_double(statement, 3), vc: sqlite3_column_double(statement, 4), carbo: sqlite3_column_double(statement, 5), cal: sqlite3_column_double(statement, 6), qualityDay: Int(sqlite3_column_int(statement, 7)), brief: String(cString: sqlite3_column_text(statement, 8)))
                                         
                searchResults.append(newItem)
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
        categoryCollection.reloadData()
    }
    
    @objc func finishAdding(_ notification: NSNotification) {
        self.searchResults = []
        self.searchBar.text = ""
        self.searchTable.reloadData()
    }

}

extension AddingVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}
