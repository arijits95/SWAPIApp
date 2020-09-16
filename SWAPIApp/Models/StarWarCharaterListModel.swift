//
//  StarWarCharaterListModel.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import ObjectMapper

class StarWarCharacterListModel: Mappable {
    
    var totalCount: Int = 0
    var nextPageNumber: Int?
    var previousPageNumber: Int?
    var characters = [StarWarCharacterModel]()
    
    required init?(map: Map) {
        guard map.JSON["count"] != nil else {
            debugPrint("Character List Count is missing")
            return nil
        }
        guard map.JSON["results"] != nil else {
            debugPrint("Character List Results is missing")
            return nil
        }
    }
    
    func mapping(map: Map) {
        totalCount <- map["count"]
        nextPageNumber <- (map["next"], Page_Url_To_Page_Number_Transform)
        previousPageNumber <- (map["previous"], Page_Url_To_Page_Number_Transform)
        characters <- map["results"]
    }
}

let Page_Url_To_Id_Transform = TransformOf<[String], [String]>(fromJSON: { (value: [String]?) -> [String] in
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

let Page_Url_To_Page_Number_Transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
    if let value = value {
        return URL(string: value)?.query?.split(separator: "=").last?.string.int
    }
    return nil
}, toJSON: { (value: Int?) -> String? in
    if let value = value {
        return "http://swapi.dev/api/people/?page=\(value)"
    }
    return nil
})

