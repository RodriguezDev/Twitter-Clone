//
//  CreatePostViewController.swift
//  theProject
//
//  Created by Chris Rodriguez on 10/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit
import Firebase

class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTextView.delegate = self
        
        postTextView.text = "What's happening?"
        postTextView.textColor = UIColor.lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: Actions
    @IBAction func submitPost(_ sender: Any) {
        if (postTextView.text?.isEmpty)! {
            print("Error: post must have text.")
        } else {
            let post = Post(newNext: postTextView.text!)
            post.submit()
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

