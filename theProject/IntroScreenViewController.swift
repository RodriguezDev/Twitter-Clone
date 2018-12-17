//
//  IntroScreenViewController.swift
//  theProject
//
//  Created by Chris Rodriguez on 9/20/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit
import Firebase

class IntroScreenViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var logInButton: UIButton! // roundButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: Actions
    @IBAction func logInButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toLogIn", sender: self)
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        logInButton.applyDesign()
        signUpButton.applyDesign()
        
        // Force a logout 
        //try! Auth.auth().signOut()
        
        // Check if we have a logged in user.
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("User \(user) logged in.")
                self.performSegue(withIdentifier: "alreadyLoggedIn", sender: self)
            } else {
                print("No user logged in.")
            }
        }
    }
}

extension UIButton {
    func applyDesign() {
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = self.frame.height / 2 // Rounds corners completely.
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
extension String
{
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
