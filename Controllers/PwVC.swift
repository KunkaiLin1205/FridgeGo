import UIKit
import FirebaseAuth

class PwVC: UIViewController {

    // reference var
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l5: UILabel!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var pw1: UITextField!
    @IBOutlet weak var pw2: UITextField!
    @IBOutlet weak var vCode: UITextField!
    @IBOutlet weak var setBut: UIButton!
    @IBOutlet weak var vBut: UIButton!
    @IBOutlet weak var w: NSLayoutConstraint!
    @IBOutlet weak var w2: NSLayoutConstraint!
    @IBOutlet weak var w3: NSLayoutConstraint!
    
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
        
        // background color
        self.view.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.bigView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        
        self.setBut.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.setBut.layer.cornerRadius = 10
        self.vBut.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.vBut.layer.cornerRadius = 10
        
        self.pw1.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.pw2.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.vCode.backgroundColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.368, green: 0.36, blue: 0.325, alpha: 1.0))
        self.pw1.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.pw2.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.vCode.textColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
        self.pw1.isSecureTextEntry = true
        self.pw2.isSecureTextEntry = true
        self.vCode.isSecureTextEntry = false
        
        self.w.constant = self.bigView.frame.width / 2
        self.w2.constant = self.bigView.frame.width / 2
        self.w3.constant = self.bigView.frame.width / 2 - 25
        
        self.l1.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l1.font = UIFont.boldSystemFont(ofSize: 20)
        self.l2.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l3.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l4.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l5.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.b1.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.b2.tintColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
    }
    
    @IBAction func change1(_ sender: Any) {
        self.pw1.isSecureTextEntry = !pw1.isSecureTextEntry
    }
    
    @IBAction func change2(_ sender: Any) {
        self.pw2.isSecureTextEntry = !pw2.isSecureTextEntry
    }
    
    @IBAction func setPw(_ sender: Any) {
        let pn = (Auth.auth().currentUser!.phoneNumber)!
        Auth.auth().currentUser?.updateEmail(to: pn + "@fridgego.com", completion: nil)
        
        if (pw1.text != pw2.text) {
            let alert = UIAlertController(title: "两次输入的密码不一致", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        
        var verificationID = "string"
        if let temp = defaultsDB.string(forKey: "authVID") {
            verificationID = temp
        }
        
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: self.vCode.text!
        )

        Auth.auth().currentUser!.reauthenticate(with: credential) { authResult, error in
          if let error = error {
              print(error)
              let alert = UIAlertController(title: "验证码错误", message: "请重试", preferredStyle: .alert)
              let action = UIAlertAction(title: "确定", style: .default, handler: nil)
              alert.addAction(action)
              self.present(alert, animated: true)
          } else {
              Auth.auth().currentUser?.updatePassword(to: self.pw1.text!) { error in
                  if let error = error {
                      print(error)
                      let alert = UIAlertController(title: "密码不符合要求", message: "请重新输入密码", preferredStyle: .alert)
                      let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                      alert.addAction(action)
                      self.present(alert, animated: true)
                  } else {
                      let alert = UIAlertController(title: "密码设置成功", message: "", preferredStyle: .alert)
                      let action = UIAlertAction(title: "确定", style: .default) { action in
                          self.dismiss(animated: true, completion: nil)
                      }
                      alert.addAction(action)
                      self.present(alert, animated: true)
                  }
              }
          }
        }
        
        
    }
    
    @IBAction func getVcode(_ sender: Any) {
        let phoneNumber = (Auth.auth().currentUser!.phoneNumber)!
        
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
}
