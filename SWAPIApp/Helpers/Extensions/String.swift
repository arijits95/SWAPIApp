//
//  String.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation

extension String {
    
    public var int: Int? {
        return Int(self)
    }
    
    public var words: [Substring] {
        var words: [Substring] = []
        self.enumerateSubstrings(in: self.startIndex..., options: .byWords) { _, range, _, _ in
            words.append(self[range])
        }
        return words
    }
    
}

extension Substring {
    
    public var string: String {
        return String(self)
    }
    
}
