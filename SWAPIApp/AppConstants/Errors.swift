//
//  Errors.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation

enum StarWarError: Error {
    case invalidResponseFromServer
    case unknown
}
