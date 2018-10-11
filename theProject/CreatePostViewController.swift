//
//  CreatePostViewController.swift
//  theProject
//
//  Created by Chris Rodriguez on 10/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var postTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func submitPost(_ sender: Any) {
        
        if (postTextField.text?.isEmpty)! {
            print("Error: post must have text.")
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

