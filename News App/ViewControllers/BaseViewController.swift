//
//  ViewController.swift
//  News App
//
//  Created by Fernando Douglas Vieira on 15/07/21.
//

import UIKit
import IQKeyboardManagerSwift

class BaseViewController: UIViewController {
    
    var isTabBarHidden = false {
            didSet {
                toggleTabBarView(isHidden: isTabBarHidden)
            }
        }
    
    var alertSpinner = UIAlertController()

    override func loadView() {
        let baseView = IQPreviousNextView()
        view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let pushVerticallyViewController: CATransition = {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        return transition
    }()
    
    func appearCrossDissolve(with: UILabel, isHidden: Bool) {
        UIView.transition(with: with,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
                            with.isHidden = isHidden
                          }, completion: nil)
    }
    
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert,
                   doAction: UIAlertAction = UIAlertAction(title: MessageType.ok.message, style: .cancel, handler: nil),
                   elseAction: UIAlertAction? = nil, thirdAction: UIAlertAction? = nil, cancelAction: UIAlertAction? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(doAction)
        if let elseAction = elseAction {
            alert.addAction(elseAction)
        }
        if let thirdAction = thirdAction {
            alert.addAction(thirdAction)
        }
        if let cancelAction = cancelAction {
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSpinner() {
        let loading = UIAlertController(title: nil, message: MessageType.pleaseWait.message, preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        DispatchQueue.main.async {
            loading.view.addSubview(loadingIndicator)
            self.present(loading, animated: true, completion: nil)
        }
        alertSpinner = loading
    }
    
    func removeAlertSpinner(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.alertSpinner.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func dismissViewController() {
        let dismissTransition:CATransition = CATransition()
        dismissTransition.duration = 0.5
        dismissTransition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        dismissTransition.type = CATransitionType.reveal
        dismissTransition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(dismissTransition, forKey: kCATransition)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    private func toggleTabBarView(isHidden: Bool) {
        if let tabBar = self.tabBarController as? NewsTabBarController {
            tabBar.setTabBarHidden(isHidden)
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                UIView.animate(withDuration: 0.2) {
                    tabBar.newsTabBarView.isHidden = isHidden
                }
            }
        }
    }
}

