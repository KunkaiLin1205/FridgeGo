import SQLite3
import Foundation

class RecipeDB {
    
    static let instance = RecipeDB()
    
    let databaseName = "recipe.db"
    
    func getDBP() -> OpaquePointer? {
        var dBP: OpaquePointer?
        
        let documentDatabasePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(databaseName).path
        
        if FileManager.default.fileExists(atPath: documentDatabasePath) {
            print("done")
        } else {
            guard let bundleDataP = Bundle.main.resourceURL?.appendingPathComponent(databaseName).path else {
                print("error")
                return nil
            }
            
            do {
                try FileManager.default.copyItem(atPath: bundleDataP, toPath: documentDatabasePath)
                print("copied")
            } catch {
                print("error2")
                return nil
            }
        }
        
        if sqlite3_open(documentDatabasePath, &dBP) == SQLITE_OK {
            print("done")
        } else {
            print("not done")
        }
        
        return dBP
    }
}
