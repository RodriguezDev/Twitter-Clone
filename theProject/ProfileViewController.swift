//
//  ProfileViewController.swift
//  theProject
//
//  Created by Chris Rodriguez on 12/28/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let userReference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var editDisplayNameOutlet: UIButton!
    @IBOutlet weak var logoutOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editDisplayNameOutlet.roundButton()
        logoutOutlet.roundButton()
        profileImage.maskCircle(anyImage: UIImage(named: "defaultProfileImage.jpg")!)
        
        userReference.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            self.displayName.text = value!["displayName"] as? String
            self.username.text = "@\(value!["username"] as! String)"
        }) { (error) in
            print(error.localizedDescription)
        }
        
        let UITapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tappedImage(sender:)))
        UITapRecognizer.delegate = self
        self.profileImage.addGestureRecognizer(UITapRecognizer)
        self.profileImage.isUserInteractionEnabled = true
        
        if let cachedImage = images["\(Auth.auth().currentUser!.uid).jpg"] {
            self.profileImage.image = cachedImage
        } else {
            downloadImage(path: "profileImages/\(Auth.auth().currentUser!.uid).jpg")
        }
    }
    
    @objc func tappedImage(sender: UITapGestureRecognizer) {
        ImagePickerManager().pickImage(self){ image in
            self.uploadImagePic(img1: image)
            self.profileImage.image = image
            
        }
    }
    
    @IBAction func editDisplayName(_ sender: Any) {
        
        let currentName = self.displayName.text
        
        let alert = UIAlertController(title: "Hey \(currentName!)", message: "Enter a new display name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = currentName
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [weak alert] (_) in
            return
        }))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
            let enteredText = alert!.textFields![0].text!
            
            if enteredText.count > 0 {
                self.userReference.child("displayName").setValue(enteredText)
                self.displayName.text = enteredText
            } else {
                self.displayName.text = currentName
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: "Cause this will do it.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "logoutToIntro", sender: nil)
            } catch let err {
                print(err)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func uploadImagePic(img1 :UIImage){
        var data = Data()
        data = UIImageJPEGRepresentation(img1, 0.1)!
        // Create a reference to the file you want to upload
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("profileImages/\(Auth.auth().currentUser!.uid).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let uploadTask = riversRef.putData(data, metadata: metaData) { (metadata, error) in
            guard let metadata = metadata else {
                return  // Error
            }
            
            let size = metadata.size
            
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return  // Error
                }
            }
        }
        
    }
    
    func downloadImage(path: String) {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(path)
        
        imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                UIView.transition(with: self.profileImage, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.profileImage.image = image
                }, completion: nil)
            }
        }
    }
    
}
