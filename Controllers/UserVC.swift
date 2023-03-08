import UIKit
import Firebase

class UserVC: UIViewController {
    // reference var
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var smallView: UIView!
    
    @IBOutlet weak var bigTitle: UILabel!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var line5: UIView!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UIButton!
    @IBOutlet weak var l3: UIButton!
    @IBOutlet weak var l4: UIButton!
    @IBOutlet weak var l5: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // other var
    let defaultsDB = UserDefaults.standard
    let db = Firestore.firestore()
    
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
        
        self.view.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.22, green: 0.39, blue: 0.73, alpha: 1.0))
        
        // view color
        self.bigView.layer.cornerRadius = 8
        self.bigView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.smallView.layer.cornerRadius = 8
        self.smallView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0), dark: UIColor(red: 0.13, green: 0.22, blue: 0.37, alpha: 1.0))
        
        self.imageView.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.bigTitle.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.bigTitle.font = UIFont.boldSystemFont(ofSize: 20)
        
        let pn = (Auth.auth().currentUser!.phoneNumber)!
        
        let docRef = db.collection(pn).document("UserID")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userId = document.data()!["ID"] as? String
                self.userName.text = userId
            } else {
                let index = pn.count - 4
                self.userName.text = "****" + pn[index...]
            }
        }
        
        let index = pn.count - 4
        self.l1.text = "绑定手机号: " + pn[0..<5] + "****" + pn[index...]
        self.l1.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l1.font = UIFont.boldSystemFont(ofSize: 15)
        self.l2.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l3.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l4.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l5.tintColor = .red
        self.userName.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.userName.font = UIFont.boldSystemFont(ofSize: 15)
        
        self.line1.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.line2.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.line3.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.line4.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
        self.line5.backgroundColor = UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0)
    
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
                    
            NotificationCenter.default.post(name: Notification.Name("com.login"), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name("com.logOut"), object: nil, userInfo: nil)
            
            let alert = UIAlertController(title: "成功登出用户", message: "已登出", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true)
            
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        let user = Auth.auth().currentUser
        let collec1 = Auth.auth().currentUser!.phoneNumber! + "R"
        let collec2 = Auth.auth().currentUser!.phoneNumber! + "C"
        let collec3 = Auth.auth().currentUser!.phoneNumber!
        var collec4 = "1"
        let docRef = db.collection(collec3).document("History")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                collec4 = document.data()!["Addr"] as! String
            } else {
                print("Document does not exist")
                }
            }
                    
        let alert = UIAlertController(title: "确定删除用户", message: "这将删除所有收藏以及云端记录", preferredStyle: .alert)
                    
        let action_1 = UIAlertAction(title: "确定", style: .default) { (action_1) in
            user?.delete { error in
                if let error = error {

                } else {
                    self.db.collection(collec1).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                self.db.collection(collec1).document(document.documentID).delete()
                            }
                        }
                    }
                    self.db.collection(collec2).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                self.db.collection(collec2).document(document.documentID).delete()
                            }
                        }
                    }
                    self.db.collection(collec3).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                self.db.collection(collec3).document(document.documentID).delete()
                            }
                        }
                    }
                    self.db.collection(collec4).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                self.db.collection(collec4).document(document.documentID).delete()
                            }
                        }
                    }
                    NotificationCenter.default.post(name: Notification.Name("com.login"), object: nil, userInfo: nil)
                    NotificationCenter.default.post(name: Notification.Name("com.logOut"), object: nil, userInfo: nil)
                }
            }
        }
        let action_2 = UIAlertAction(title: "取消", style: .default, handler: nil)
                    
        alert.addAction(action_1)
        alert.addAction(action_2)
        self.present(alert, animated: true)
    }
    
    @IBAction func changeUserName(_ sender: Any) {
        var textField = UITextField()
           
        let alert = UIAlertController(title: "更改用户名", message: "请输入新用户名", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "用户名"
            textField = alertTextField
        }
           
        let action_1 = UIAlertAction(title: "确定", style: .default) { (action_1) in
            self.userName.text! = textField.text!
            let pn = (Auth.auth().currentUser!.phoneNumber)!
            self.db.collection(pn).document("UserID").setData(["ID" : textField.text!])
            NotificationCenter.default.post(name: Notification.Name("com.login"), object: nil, userInfo: nil)
        }
           
        let action_2 = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        alert.addAction(action_1)
        alert.addAction(action_2)
        
        present(alert, animated: true)
    }
    
    @IBAction func setPw(_ sender: Any) {
        performSegue(withIdentifier: "SetPw", sender: self)
    }
}

