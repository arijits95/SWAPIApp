//
//  Device.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 17/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import UIKit

extension UIDevice {
    
    static var isIPhone5: Bool {
        return (UIScreen.main.bounds.width == 320)
    }
    
}
