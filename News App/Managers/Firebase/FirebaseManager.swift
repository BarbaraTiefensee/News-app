//
//  FirebaseAuthManager.swift
//  News App
//
//  Created by Premier20 on 23/07/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import KeychainSwift

class FirebaseManager {
    
    let database = Database.database().reference()
    let storage = Storage.storage().reference()
    let keychain = KeychainSwift()
    
    func createUser(firstName: String, lastName: String, email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if (authResult?.user) != nil {
                guard let users = Auth.auth().currentUser else { return }
                self.database.child("users").child(users.uid).child("firstname").setValue(firstName)
                self.database.child("users").child(users.uid).child("lastname").setValue(lastName)
                Auth.auth().currentUser?.getIDToken(completion: { sucess, error in
                    if let sucessful = sucess {
                        self.keychain.set(sucessful, forKey: "isLogged")
                    }
                })
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func signIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                Auth.auth().currentUser?.getIDToken(completion: { sucess, error in
                    if let sucessful = sucess {
                        self.keychain.set(sucessful, forKey: "isLogged")
                    }
                })
                completionBlock(true)
            }
        }
    }
    
    func signOut() -> Bool{
        let user = Auth.auth().currentUser
        if user != nil{
            do{
                try Auth.auth().signOut()
                return true
            }catch {
                return false
            }
        }
        return true
    }
    
    func sendPasswordReset(withEmail email: String, completionBlock: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completionBlock?(error)
        }
    }
    
    func updateEmail(to email: String, completionBlock: ((Error?) -> ())? = nil) {
        Auth.auth().currentUser?.updateEmail(to: email, completion: { error in
            completionBlock?(error)
        })
    }
    
    func reauthenticate(currentPassword: String, newPassword: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { result, error in
            if error == nil {
                completion(true)
                self.changePassword(to: newPassword)
            }
            else {
                completion(false)
            }
        })
    }
    
    func changePassword(to currentPassword: String?, completionBlock: ((Error?) -> ())? = nil) {
        guard let password = currentPassword else { return }
        Auth.auth().currentUser?.updatePassword(to: password, completion: { error in
            completionBlock?(error)
        })
    }
    
    func updateData(firstName: String, lastName: String, userUID: String) {
        let ref = database.child("users").child(userUID)
        
        ref.updateChildValues(["firstname" : firstName,
                               "lastname": lastName])
    }
    
    func observeSingleEventOfValue(in userID: String, value: @escaping (_ value: [String: String]) -> Void) {
        let database = Database.database().reference()
        
        database.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            guard let dataValue = snapshot.value as? [String: String] else { return }
            value(dataValue)
        }
    }
    
    func uploadImage(imageData: Data, userID: String, storageReference: StorageReference, showAlertOrError: @escaping(_ success: Bool, _ error: Error?) -> Void) {
        let uploadTask = storageReference.putData(imageData, metadata: nil) { ( metadata, error) in
            if let error = error {
                showAlertOrError(false, error)
            } else {
                storageReference.downloadURL { URL, error in
                    if let error = error {
                        showAlertOrError(false, error)
                    } else {
                        guard let urlString = URL?.absoluteString else { return }
                        self.appendTo(child: "imageURL", in: userID, value: urlString)
                    }
                }
            }
        }
        uploadTask.observe(.progress, handler: { (snapshot) in
            if ((snapshot.progress?.isFinished) != nil) {
                showAlertOrError(true, nil)
            }
        })
    }
    
    func appendTo(child: String, in userID: String, value: String) {
        self.database.child("users").child(userID).child(child).setValue(value)
    }
}
