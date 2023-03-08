import Foundation

class recipeInfo {
    var Id : Int
    var title : String
    var time : String
    var people : String
    var intro : String
    var tip : String
    
    init(Id : Int, title : String, time : String, people : String, intro : String, tip : String) {
        self.Id = Id
        self.title = title
        self.time = time
        self.people = people
        self.intro = intro
        self.tip = tip
    }
    
}
