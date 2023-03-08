import UIKit

class TabBarVC : UITabBarController {
    
    let defaultsDB = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor.dynamicColor(light: UIColor(red: 0.32, green: 0.56, blue: 0.81, alpha: 1.0), dark: UIColor(red: 0.22, green: 0.39, blue: 0.73, alpha: 1.0))
        self.tabBar.unselectedItemTintColor = UIColor.dynamicColor(light: UIColor(red: 0.56, green: 0.75, blue: 0.86, alpha: 1.0), dark:  UIColor(red: 0.635, green: 0.86, blue: 0.95, alpha: 1.0))
        self.selectedIndex = 0
        
        for t in self.tabBar.items! {
            t.titlePositionAdjustment.vertical = 0
            t.imageInsets.top = 0
            t.imageInsets.bottom = 0
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(modifyTheme(_:)), name: Notification.Name("com.theme"), object: nil)
        
        var info = [String: Int]()
        if let tempTheme = defaultsDB.string(forKey: "FGTheme") {
            if (tempTheme == "light") {
                info["theme"] = 0
            } else {
                info["theme"] = 1
            }
        } else {
            info["theme"] = 0
        }
        
        NotificationCenter.default.post(name: Notification.Name("com.theme"), object: nil, userInfo: info)
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

