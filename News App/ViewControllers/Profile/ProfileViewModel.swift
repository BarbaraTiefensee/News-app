//
//  UserModel.swift
//  News App
//
//  Created by Premier on 02/08/21.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Firebase

protocol ProfileViewModelDelegate {
    func didLoadName(result: Result<String, Error>)
    func didLoadEmail(result: Result<String, Error>)
    func didLoadProfilePicture(result: Result<String, Error>)
    func moveToViewController(firstname: String?, lastName: String?, email: String?)
}

class ProfileViewModel {
    
    private(set) var userFirstName = String()
    private(set) var userLastName = String()
    private(set) var userEmail = String()
    private(set) var profilePicURL = String()
    
    private var delegate: ProfileViewModelDelegate
    public let firebase = FirebaseManager()
    
    private let databaseReference = Database.database().reference()
    private let currentUser = Auth.auth().currentUser
    
    init(delegate: ProfileViewModelDelegate) {
        self.delegate = delegate
        loadData()
    }
    
    func loadData() {
        fetchUserName()
        fetchUserEmail()
        fetchProfilePicURL()
    }
    
    private func fetchUserName() {
        guard let user = currentUser else { return }
        
        firebase.observeSingleEventOfValue(in: user.uid) { [weak self] value in
            guard let firstName = value["firstname"],
                  let lastName = value["lastname"] else {
                self?.delegate.didLoadName(result: Result.failure(NSError(domain: "Não foi possível carregar os dados.", code: 0, userInfo: nil)))
                return
            }
            
            self?.userFirstName = firstName
            self?.userLastName = lastName
            self?.delegate.didLoadName(result: Result.success(firstName + " " + lastName))
        }
    }
    
    private func fetchUserEmail() {
        guard let userEmail = currentUser?.email else { return }
        self.userEmail = userEmail
        self.delegate.didLoadEmail(result: Result.success(userEmail))
    }
    
    private func fetchProfilePicURL() {
        guard let user = currentUser else { return }
        
        firebase.observeSingleEventOfValue(in: user.uid) { value in
            self.profilePicURL = value["imageURL"] ?? ""
            self.delegate.didLoadProfilePicture(result: Result.success(self.profilePicURL))
        }
    }

    func showEditProfileViewController() {
        delegate.moveToViewController(firstname: userFirstName, lastName: userLastName, email: userEmail)
    }
    
}
