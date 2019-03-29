//
//  PostListCell.swift
//  theProject
//
//  Created by Chris Rodriguez on 10/20/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit
import Firebase

class PostListCell: UITableViewCell {
    
    var post:Post!
    
    @IBOutlet weak var postUserImage: UIImageView!
    @IBOutlet weak var postUserDisplayName: UILabel!
    @IBOutlet weak var postUserHandle: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        post.ref.child("likes").setValue(post.likes + 1)
        likeButton.setTitle(String(post.likes + 1) + " likes", for: .normal)
    }
    
    func downloadProfileImage(name: String) {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("profileImages/\(name)")
        
        imageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
            if let error = error {
                print("Image not available.")
            } else {
                print("Cell image downloaded")
                let image = UIImage(data: data!)
                images[name] = image
                
                UIView.transition(with: self.postUserImage, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.postUserImage.image = image
                }, completion: nil)
            }
        }
    }
    
}
