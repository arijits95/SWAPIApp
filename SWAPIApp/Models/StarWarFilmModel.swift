//
//  StarWarFilm.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 15/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import ObjectMapper

class StarWarFilmModel: Mappable {
    
    var title: String!
    var openingCrawl: String!
    
    required init?(map: Map) {
        guard map.JSON["title"] != nil else {
            debugPrint("Film title is missing")
            return nil
        }
        guard map.JSON["opening_crawl"] != nil else {
            debugPrint("Film Opening Crawl is missing")
            return nil
        }
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        openingCrawl <- map["opening_crawl"]
    }
}

extension StarWarFilmModel {
    
    var openingCrawlWordCount: Int {
        return self.openingCrawl.words.count
    }
    
}
