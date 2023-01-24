//
//  UIScreen+Extension.swift
//  News App
//
//  Created by Premier on 26/07/21.
//

import UIKit

extension UIScreen {
    
    open class var is4InchDevice: Bool {
        
        return UIScreen.main.bounds.height <= 760
    }
}
