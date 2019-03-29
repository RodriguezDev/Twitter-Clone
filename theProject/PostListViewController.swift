import UIKit
import Firebase

let NUM_OF_POSTS: UInt = 25
var images = [String: UIImage]()

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlets
    @IBOutlet weak var postTable: UITableView!
    
    // MARK: Actions
    var refreshControl: UIRefreshControl!
    
    // MARK: Database variables
    var posts = [Post]()
    
    let postsRef = Database.database().reference().child("Posts")
    
    // MARK: Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        postTable.addSubview(refreshControl)
        
        postTable.rowHeight = UITableViewAutomaticDimension
        postTable.estimatedRowHeight = 80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPostsAndRefresh()
    }
    
    @objc func refresh(_ sender: Any) {
        getPostsAndRefresh()
        self.refreshControl.endRefreshing()
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
        
        // Get username & display name dynamically
        Database.database().reference().child("users").child(posts[indexPath.row].creatorUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            cell.postUserDisplayName.text = value!["displayName"] as? String
            cell.postUserHandle.text = "@\(value!["username"] as! String)"
        }) { (error) in
            print(error.localizedDescription)
        }
        
        cell.post = posts[indexPath.row]
        
        cell.postText.numberOfLines = 0
        cell.postText.text = posts[indexPath.row].text
        cell.postDate.text = "| " + posts[indexPath.row].dateFormat()
        cell.likeCount.text = String(posts[indexPath.row].likes)
        
        cell.postUserImage.maskCircle(anyImage: UIImage(named: "defaultProfileImage.jpg")!)
        
        let profileImageName = "\(cell.post.creatorUserID).jpg"
        
        if let image = images[profileImageName] {
            cell.postUserImage.image = image
        } else {
            // Removed download to save on bandwidth.
            //cell.downloadProfileImage(name: "\(cell.post.creatorUserID).jpg")
        }
        
        return cell
    }
    
    // MARK: My functions. Yay.
    func getPostsAndRefresh() {
        let query = postsRef.queryOrdered(byChild: "dateTime").queryLimited(toLast: NUM_OF_POSTS) // Get 25 most recent posts.
        
        query.observe(.value, with: { (snapshot) in
            self.posts.removeAll()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                self.posts.append(Post(newSnapshot: childSnapshot))
            }
            self.posts.reverse() // Good design? Probably not.
            print("Posts retrieved: \(self.posts.count)")
            self.postTable.reloadData()
        })
    }
}
