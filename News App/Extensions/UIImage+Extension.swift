//
//  UIImage+Extension.swift
//  News App
//
//  Created by Gabriel Varela on 16/07/21.
//

import UIKit

extension UIImage {
    
    open class var saveIcon: UIImage? {
        return UIImage(named: "saveIcon")?.withRenderingMode(.alwaysTemplate)
    }
    
    open class var lockIcon: UIImage? {
        return UIImage(named: "lockIcon")?.withRenderingMode(.alwaysTemplate)
    }
    
    open class var userIcon: UIImage? {
        return UIImage(named: "userIcon")?.withRenderingMode(.alwaysTemplate)
    }
    
    open class var backIcon: UIImage? {
        return UIImage(named: "backIcon")
    }
    
    open class var placeholder: UIImage? {
        return UIImage(named: "placeholder")
    }
    
    open class var menuIcon: UIImage? {
        return UIImage(named: "menuIcon")?.withRenderingMode(.alwaysTemplate)
    }
    
    open class var savedIcon: UIImage? {
        return UIImage(named: "savedIcon")?.withRenderingMode(.alwaysTemplate)
    }
    
    open class var mailIcon: UIImage? {
        return UIImage(named: "mailIcon")?.withRenderingMode(.alwaysTemplate)
    }
    
    open class var accountIcon: UIImage? {
        return UIImage(named: "accountIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    open class var notificationIcon: UIImage? {
        return UIImage(named: "notificationIcon")
    }
    
    open class var homeIcon: UIImage? {
        return UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    open class var selectedHomeIcon: UIImage? {
        return UIImage(named: "selectedHomeIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    open class var selectedAccountIcon: UIImage? {
        return UIImage(named: "selectedAccountIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    open class var editIcon: UIImage? {
        return UIImage(named: "editIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    open class var eyeClosedIcon: UIImage? {
        return UIImage(named: "eyeClosedIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    open class var eyeOpenIcon: UIImage? {
        return UIImage(named: "eyeOpenIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    open class var passwordIcon: UIImage? {
        return UIImage(named: "passwordIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    open class var exitIcon: UIImage? {
        return UIImage(named: "exitIcon")?.withRenderingMode(.alwaysOriginal)
    }
}
