//
//  Errors.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation

public enum StarWarError: Error {
    case invalidResponseFromServer
    case unknown
    
    var errorDescription: String {
        switch self {
        case .invalidResponseFromServer: return "Something went wrong. Please try again later."
        case .unknown: return "Something went wrong. Please try again later."
        }
    }
}

extension Error {
    
    public var asStarWarError: StarWarError? {
        self as? StarWarError
    }
    
}
