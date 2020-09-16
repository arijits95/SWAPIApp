//
//  StarWarCharacter.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 15/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import ObjectMapper


class StarWarCharacterModel: Mappable {
    
    var name: String!
    var birthYear: String?
    var height: String?
    var mass: String?
    var hairColor: String?
    var skinColor: String?
    var eyeColor: String?
    var gender: String?
    var filmIds = [String]()
    
    required init?(map: Map) {
        guard map.JSON["name"] != nil else {
            debugPrint("Character Name is missing")
            return nil
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        birthYear <- map["birth_year"]
        height <- map["height"]
        mass <- map["mass"]
        hairColor <- (map["hair_color"], NA_To_Optional_String_Transform)
        skinColor <- map["skin_color"]
        eyeColor <- map["eye_color"]
        gender <- (map["gender"], NA_To_Optional_String_Transform)
        filmIds <- (map["films"], Film_Url_To_Id_Transform)
    }

}

//let genderTransform = TransformOf<Gender, String>(fromJSON: { (value: String?) -> Gender? in
//    if let value = value {
//        return Gender.getGender(forKey: value)
//    }
//    return nil
//}, toJSON: { (value: Gender?) -> String? in
//    if let value = value {
//        return value.rawValue
//    }
//    return "n/a"
//})

let Film_Url_To_Id_Transform = TransformOf<[String], [String]>(fromJSON: { (value: [String]?) -> [String] in
    if let value = value {
        return value.map { URL(string: $0)?.lastPathComponent ?? "" }.filter { $0 != "" }
    }
    return []
}, toJSON: { (value: [String]?) -> [String] in
    if let value = value {
        return value.map { "http://swapi.dev/api/films/\($0)/" }
    }
    return []
})

let NA_To_Optional_String_Transform = TransformOf<String?, String>(fromJSON: { (value: String?) -> String?? in
    if let value = value {
        return value == "n/a" ? nil : value
    }
    return nil
}, toJSON: { (value: String??) -> String? in
    if let value = value {
        return value
    }
    return "n/a"
})
