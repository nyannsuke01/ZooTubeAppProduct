//
//  UIColor-Extension.swift
//  LoginWithFirebaseApp
//
//  Created by user on 2020/02/27.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

extension UIColor {
    //色をrgb値で入力するためのextension
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
}
