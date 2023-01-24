//
//  ChangeProfileViewModel.swift
//  News App
//
//  Created by Gabriel Varela on 11/08/21.
//

import Foundation
import Firebase
import FirebaseAuth

protocol ChangeProfileViewModelDelegate {
    func didSet()
}

protocol ChangeProfileViewModelProtocol {
    var userFirstName: String? { get }
    var userLastName: String? { get }
    var userEmail: String? { get }
    func updateName(firstname: String?, lastName: String?, userUid: String?)
    func reauthenticateAndChangePassword(currentPassword: String?, newPassword: String?, completion: @escaping (_ success: Bool) -> Void)
    func updateEmail(email: String?)
}

class ChangeProfileViewModel: ChangeProfileViewModelProtocol {
    
    private let firebase = FirebaseManager()
    
    var userFirstName: String?
    
    var userLastName: String?
    
    var userEmail: String?
    
    var delegate: ChangeProfileViewModelDelegate?
    
    init(firstName: String?, lastName: String?, email: String?) {
        self.userFirstName = firstName
        self.userLastName = lastName
        self.userEmail = email
    }
    
    func updateName(firstname: String?, lastName: String?, userUid: String?) {
        guard let newFirstName = firstname, let newLastName = lastName, let user = userUid else { return }
        firebase.updateData(firstName: newFirstName, lastName: newLastName, userUID: user)
    }
    
    func updateEmail(email: String?) {
        guard let newEmail = email else { return }
        firebase.updateEmail(to: newEmail)
    }
    
    func reauthenticateAndChangePassword(currentPassword: String?, newPassword: String?, completion: @escaping (_ success: Bool) -> Void) {
        guard let password = currentPassword else { return }
        guard let newPassword = newPassword else { return }
        firebase.reauthenticate(currentPassword: password, newPassword: newPassword) { success in
            if success == true {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
