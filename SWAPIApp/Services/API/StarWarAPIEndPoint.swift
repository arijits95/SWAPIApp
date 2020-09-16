//
//  StarWarAPIEndPoint.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import Alamofire

let StarWarServerBaseUrl = "https://swapi.dev/api"

enum StarWarAPIEndPoint {
    
    case characters(pageNumber: Int), filmDetails(id: String)
    
    var url: URL {
        switch self {
        case .characters(let pageNumber):
            return URL(string: StarWarServerBaseUrl + ((pageNumber == 1) ? "/people/" : "/people/?page=\(pageNumber)"))!
        case .filmDetails(let id):
            return URL(string: StarWarServerBaseUrl + "/films/\(id)")!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .characters: return .get
        case .filmDetails: return .get
        }
    }

}
