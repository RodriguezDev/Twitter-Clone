//
//  Post.swift
//  theProject
//
//  Created by Chris Rodriguez on 10/21/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation
import Firebase

class Post {
    var text: String = ""
    var likes: Int = 0
    var userID: String = ""
    var username: String = ""
    var dateTime: Date = Date()
    
    let ref: DatabaseReference!
    
    init(newNext: String) {
        text = newNext
        ref = Database.database().reference().child("Posts").childByAutoId()
        userID = Auth.auth().currentUser!.uid
        dateTime = Date()
    }
    init(newSnapshot: DataSnapshot) {
        ref = newSnapshot.ref
        if let value = newSnapshot.value as? [String: Any] {
            text = value["postText"] as! String
            likes = value["likes"] as! Int
            userID = value["postCreator"] as! String
            username = value["postUsername"] as! String
            dateTime = Date(timeIntervalSinceReferenceDate: value["dateTime"] as! Double)
        }
    }
    
    func submit() {
        let genRef = Database.database().reference()
        // Get the username from the user table.
        genRef.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.username = value!["username"] as! String
            
            self.ref.setValue(self.buildDictionary())
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func buildDictionary() -> [String: Any] {
        return [
            "postText": text,
            "likes": likes,
            "postCreator": userID,
            "postUsername": username,
            "dateTime": dateTime.timeIntervalSinceReferenceDate
        ]
    }
}
