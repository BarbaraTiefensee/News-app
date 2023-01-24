//
//  UINavigationController+Extension.swift
//  News App
//
//  Created by Premier20 on 03/08/21.
//

import UIKit

extension UINavigationController {
    
    func popViewController(animated: Bool, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
}
