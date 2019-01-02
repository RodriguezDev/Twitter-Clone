//
//  ProfileViewController.swift
//  theProject
//
//  Created by Chris Rodriguez on 12/28/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

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
        
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            self.displayName.text = value!["displayName"] as? String
            self.username.text = "@\(value!["username"] as! String)"
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func editDisplayName(_ sender: Any) {
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
    
}
