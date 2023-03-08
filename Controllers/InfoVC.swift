import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var textView: UITextView!
    
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
        self.textView.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.756, green: 0.949, blue: 0.98, alpha: 1.0), dark: UIColor(red: 0.078, green: 0.149, blue: 0.36, alpha: 1.0))
        self.textView.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        self.l1.textColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1.0))
    }
    
}
