//
//  Enums.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 15/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation

enum Gender: String {
    
    case male = "male", female = "female", notAvailable
    
    static func getGender(forKey key: String) -> Gender? {
        return Gender(rawValue: key)
    }
}
