//
//  IntroScreenViewController.swift
//  theProject
//
//  Created by Chris Rodriguez on 9/20/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit

class IntroScreenViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton! // roundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.applyDesign()
        
    }
    
}

extension UIButton {
    func applyDesign() {
        //self.backgroundColor = UIColor.darkGray
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = self.frame.height / 2 // Rounds corners completely.
        self.setTitleColor(UIColor.white, for: .normal)
        
        /*
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        */
    }
}

class roundButton: UIButton { // Can be applied in the inspector in storyboard.
    override func didMoveToWindow() {
        self.backgroundColor = UIColor.darkGray
        self.layer.cornerRadius = self.frame.height / 2 // Rounds corners completely.
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
