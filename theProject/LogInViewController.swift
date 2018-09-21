//
//  LogInViewController.swift
//  theProject
//
//  Created by Chris Rodriguez on 9/20/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.applyDesign()
        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
    }
}

extension UITextField
{
    func setBottomBorder()
    {
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
