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
            dateTime = Date(timeIntervalSinceReferenceDate: value["dateTime"] as! Double)
        }
    }
    
    func submit() {
        self.ref.setValue(self.buildDictionary())
    }
    
    func buildDictionary() -> [String: Any] {
        return [
            "postText": text,
            "likes": likes,
            "postCreator": userID,
            "dateTime": dateTime.timeIntervalSinceReferenceDate
        ]
    }
}
