import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var logOrReg: UISegmentedControl!
    @IBOutlet weak var logView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var pn: UITextField!
    @IBOutlet weak var prefix: UITextField!
    @IBOutlet weak var prefix2: UITextField!
    @IBOutlet weak var pw1: UITextField!
    @IBOutlet weak var regBut: UIButton!
    @IBOutlet weak var logBut: UIButton!
    @IBOutlet weak var pn2: UITextField!
    @IBOutlet weak var pw3: UITextField!
    @IBOutlet weak var vBut: UIButton!
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var l5: UILabel!
    @IBOutlet weak var l6: UILabel!
    @IBOutlet weak var l8: UILabel!
    @IBOutlet weak var l9: UILabel!
    
    @IBOutlet weak var w1: NSLayoutConstraint!
    @IBOutlet weak var w2: NSLayoutConstraint!
    @IBOutlet weak var w4: NSLayoutConstraint!
    @IBOutlet weak var w5: NSLayoutConstraint!
    @IBOutlet weak var w6: NSLayoutConstraint!
    @IBOutlet weak var w7: NSLayoutConstraint!
    @IBOutlet weak var w8: NSLayoutConstraint!
    
    // other var
    let defaultsDB = UserDefaults.standard
    var cnt = 60
    
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
        
        Auth.auth().languageCode = "cn"
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.view.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.logView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.mainView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.regBut.layer.cornerRadius = 10
        self.logBut.layer.cornerRadius = 10
        self.vBut.layer.cornerRadius = 10
        
        self.pw1.isSecureTextEntry = true
        self.pw3.isSecureTextEntry = false
        
        if (self.logOrReg.selectedSegmentIndex == 1) {
            self.logView.isHidden = false
            self.mainView.isHidden = true
        } else {
            self.logView.isHidden = true
            self.mainView.isHidden = false
        }
        // set constraints
        self.w1.constant = self.logView.frame.width / 2
        self.w2.constant = self.logView.frame.width / 2
        self.w4.constant = self.logView.frame.width / 2
        self.w5.constant = self.logView.frame.width / 2 - 25
        self.w6.constant = self.view.frame.width * 0.8
        
        self.prefix.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.prefix2.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.pn.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.pn2.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.pw1.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.pw3.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        
        self.prefix.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.prefix2.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.pn.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.pn2.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.pw1.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.pw3.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        
        self.l1.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l2.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l3.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l5.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l6.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l8.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l9.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        
        self.b1.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        
        self.regBut.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.logBut.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.vBut.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        
        // observe
        NotificationCenter.default.addObserver(self, selector: #selector(modifyTheme(_:)), name: Notification.Name("com.theme"), object: nil)
    }
    
    @IBAction func change1(_ sender: Any) {
        self.pw1.isSecureTextEntry = !pw1.isSecureTextEntry
    }
    
    @IBAction func changeSection(_ sender: Any) {
        if (self.logOrReg.selectedSegmentIndex == 1) {
            self.logView.isHidden = false
            self.mainView.isHidden = true
        } else {
            self.logView.isHidden = true
            self.mainView.isHidden = false
        }
    }
    
    @IBAction func reg(_ sender: Any) {
        if (prefix2.text == "" || pn.text == "") {
            let alert = UIAlertController(title: "请输入手机号", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        if (pw1.text == "") {
            let alert = UIAlertController(title: "请输入密码", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        let email = "+" + self.prefix2.text! + self.pn.text! + "@fridgego.com"
        if let pw = pw1.text {
            Auth.auth().signIn(withEmail: email, password: pw) { authResult, error in
                if let error = error {
                    print(error)
                    let alert = UIAlertController(title: "手机号未注册或密码错误", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
                NotificationCenter.default.post(name: Notification.Name("com.login"), object: nil, userInfo: nil)
                NotificationCenter.default.post(name: Notification.Name("com.logIn"), object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
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

    
    @IBAction func login(_ sender: Any) {
        if (pw3.text == "") {
            let alert = UIAlertController(title: "请输入验证码", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        var verificationID = "string"
        if let temp = defaultsDB.string(forKey: "authVID") {
            verificationID = temp
        }
        
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: self.pw3.text!
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error)
                let alert = UIAlertController(title: "验证码错误", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true)
                return
            }
            
            let db = Firestore.firestore()
            let phoneNumber = "+" + self.prefix.text! + self.pn2.text!
            
            let docRef = db.collection(phoneNumber).document("History")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                } else {
                    db.collection(phoneNumber).document("History").setData(["Addr" : self.randomString(length: 16)])
                }
            }
        
    
            NotificationCenter.default.post(name: Notification.Name("com.login"), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name("com.logIn"), object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func getVCode(_ sender: Any) {
        if (prefix.text == "" || pn2.text == "") {
            let alert = UIAlertController(title: "请输入手机号", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        let phoneNumber = "+" + prefix.text! + pn2.text!
        
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
              if let error = error {
                  let alert = UIAlertController(title: "\(error.localizedDescription)", message: "", preferredStyle: .alert)
                  let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                  alert.addAction(action)
                  self.present(alert, animated: true)
                  return
              }
              UserDefaults.standard.set(verificationID, forKey: "authVID")
              self.vBut.isEnabled = false
              Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
              Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.enablefunc), userInfo: nil, repeats: false)
          }
    }
    
    
    @objc func enablefunc() {
        self.vBut.isEnabled = true
        self.vBut.setTitle("获取", for: .normal)
        self.cnt = 60
    }
    
    @objc func countDown() {
        self.vBut.setTitle(String(cnt), for: .normal)
        self.cnt -= 1
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
