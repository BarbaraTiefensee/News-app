//
//  ExtensionChangeProfile.swift
//  News App
//
//  Created by Gabriel Varela on 10/08/21.
//

import Foundation
import UIKit

// MARK: - Image Picker
extension ChangeProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: MessageType.profilePicture.message, message: MessageType.photoMessage.message, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: MessageType.cancel.message, style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: MessageType.takePicture.message, style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: MessageType.choosePhoto.message, style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    private func presentCamera() {
        let cameraView = UIImagePickerController()
        cameraView.sourceType = .camera
        cameraView.delegate = self
        cameraView.allowsEditing = true
        present(cameraView, animated: true)
    }
    
    private func presentPhotoPicker() {
        let photoPickerView = UIImagePickerController()
        photoPickerView.sourceType = .photoLibrary
        photoPickerView.delegate = self
        photoPickerView.allowsEditing = true
        present(photoPickerView, animated: true)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else { return }
        guard let userUid = currentUser else { return }
        let profileImageReference = storageReference.child("UserProfilePic").child("\(userUid).jpg")
        
        firebase.uploadImage(imageData: imageData, userID: userUid, storageReference: profileImageReference) { success, error in
            if success {
            } else {
                self.showAlert(title: MessageType.error.message, message: error?.localizedDescription ?? "")
            }
        }
        self.profilePicture.image = selectedImage
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setProfileImage(imageView: UIImageView) {
        if let user = currentUser {
            firebase.observeSingleEventOfValue(in: user) { value in
                UIImageView.loadFromProfile(urlImage: value["imageURL"], image: imageView)
            }
        }
    }
    
    @objc
    func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
}
