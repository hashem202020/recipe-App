//
//  RecipeModel.swift
//  iosTask
//
//  Created by hashem on 06/08/2021.
//

import Foundation
struct RecipeModel : Codable {
    let q : String?
    let from : Int?
    let to : Int?
    let more : Bool?
    let count : Int?
    let hits : [Hits]?

    enum CodingKeys: String, CodingKey {
        case q = "q"
        case from = "from"
        case to = "to"
        case more = "more"
        case count = "count"
        case hits = "hits"
    }
    
    //MARK:- Hits
    struct Hits : Codable {
        let recipe : Recipe?

        enum CodingKeys: String, CodingKey {
            case recipe = "recipe"
        }
    
    
    //MARK:- Recipe
    struct Recipe : Codable {
        let uri : String?
        let label : String?
        let image : String?
        let source : String?
        let url : String?
        let shareAs : String?
        let yield : Double?
        let dietLabels : [String]?
        let healthLabels : [String]?
        let cautions : [String]?
        let ingredientLines : [String]?
        let calories : Double?
        let totalWeight : Double?
        let totalTime : Double?
        let cuisineType : [String]?
        let mealType : [String]?
        let dishType : [String]?

        enum CodingKeys: String, CodingKey {

            case uri = "uri"
            case label = "label"
            case image = "image"
            case source = "source"
            case url = "url"
            case shareAs = "shareAs"
            case yield = "yield"
            case dietLabels = "dietLabels"
            case healthLabels = "healthLabels"
            case cautions = "cautions"
            case ingredientLines = "ingredientLines"
            case calories = "calories"
            case totalWeight = "totalWeight"
            case totalTime = "totalTime"
            case cuisineType = "cuisineType"
            case mealType = "mealType"
            case dishType = "dishType"
        }
    }

}
}
