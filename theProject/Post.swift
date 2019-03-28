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
    var creatorUserID: String = ""
    var dateTime: Date = Date()
    
    let ref: DatabaseReference!
    
    init(newNext: String) {
        text = newNext
        ref = Database.database().reference().child("Posts").childByAutoId()
        creatorUserID = Auth.auth().currentUser!.uid
        dateTime = Date()
    }
    init(newSnapshot: DataSnapshot) {
        ref = newSnapshot.ref
        if let value = newSnapshot.value as? [String: Any] {
            text = value["postText"] as! String
            likes = value["likes"] as! Int
            creatorUserID = value["postCreator"] as! String
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
            "postCreator": creatorUserID,
            "dateTime": dateTime.timeIntervalSinceReferenceDate
        ]
    }
    func dateFormat() -> String {
        // Takes the date and presents it in a meaningful way based on current date.
        var result: String
        let difference = Date().timeIntervalSinceReferenceDate - dateTime.timeIntervalSinceReferenceDate
        
        if difference < 60 {
            result = "\(Int(difference))s"
        } else if difference < 3600 {
            result = "\(Int(difference / 60))m"
        } else if difference < 86400 {
            result = "\(Int(difference / 3600))h"
        } else if difference < 86400 * 7 {
            result = "\(Int(difference / 86400))d"
        } else {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .short
            result = formatter.string(from: dateTime)   // Just print the date.
        }
        
        return result
    }
}
