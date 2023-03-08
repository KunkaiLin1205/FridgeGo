import Foundation

public struct cloudItem: Codable {

    let itemName : String
    let category : Int
    let protein : Double
    let fat : Double
    let vc : Double
    let carbo : Double
    let cal : Double
    let brief : String
    let num : Int
    let expDate : String
    let ifFresh : Bool
    let com : String
    
    enum CodingKeys: String, CodingKey {
        case itemName
        case category
        case protein
        case fat
        case vc
        case carbo
        case cal
        case brief
        case num
        case expDate
        case ifFresh
        case com
    }

}
