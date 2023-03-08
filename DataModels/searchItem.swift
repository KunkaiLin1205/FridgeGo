import Foundation

class searchItem {
    var itemName : String
    var category : String
    var protein : Double
    var fat : Double
    var vc : Double
    var carbo : Double
    var cal : Double
    var qualityDay : Int
    var brief : String
    
    init(itemName : String, category : String, protein : Double, fat : Double, vc : Double, carbo : Double, cal : Double, qualityDay : Int, brief : String) {
        self.itemName = itemName
        self.category = category
        self.protein = protein
        self.fat = fat
        self.vc = vc
        self.carbo = carbo
        self.cal = cal
        self.qualityDay = qualityDay
        self.brief = brief
    }
    
}
