//
//  PostListViewController.swift
//  theProject
//
//  Created by Chris Rodriguez on 10/10/18.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit
import Firebase

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlets
    @IBOutlet weak var postTable: UITableView!
    
    // MARK: Actions
    var refreshControl: UIRefreshControl!
    
    // MARK: Database variables
    var posts = [String]()
    let postsRef = Database.database().reference().child("Post")
    
    // MARK: Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        postTable.addSubview(refreshControl)
        
        postTable.rowHeight = 80.0     // TODO: Make this dynamic. 80 is a good min though (until reactions get added)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPostsAndRefresh()
    }
    
    @objc func refresh(_ sender: Any) {
        getPostsAndRefresh()
        self.refreshControl.endRefreshing() // Works??
    }
    
    // MARK: Table view functions.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostListCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostListCell
        cell.postText.text = posts[indexPath.row]
        cell.postUserImage.maskCircle(anyImage: UIImage(named: "defaultProfileImage.jpg")!)
        return cell
    }
    
    // MARK: My functions. Yay.
    func getPostsAndRefresh() {
        postsRef.observe(.value, with: { (snapshot) in
            self.posts.removeAll()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                
                if let value = childSnapshot.value as? [String: Any] {
                    let text = value["postText"] as! String
                    self.posts.append(text)
                }
            }
            self.postTable.reloadData()
        })
    }
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
