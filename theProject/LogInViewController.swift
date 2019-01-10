import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        attemptLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // try! Auth.auth().signOut() // Force a logout. ONLY for debug.
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        continueButton.applyDesign()
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        
        self.backgroundImage.image = UIImage(named: "escheresque.png")!.resizableImage(withCapInsets: .zero)    // Repeat image.
        self.errorLabel.text = " "
        self.errorLabel.numberOfLines = 0
        self.passwordTextField.returnKeyType = UIReturnKeyType.go
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Check if user is already logged in.
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("User \(user.uid) logged in.")
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            } else {
                print("No user logged in.")
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // If the user taps enter, attempt login and resign keyboard.
        
        textField.resignFirstResponder()
        attemptLogin()
        return true
    }
    
    func attemptLogin() {
        // Attempts user log in using email & password.
        // Success -> segue
        
        if let usernameText = emailTextField.text, !usernameText.isEmpty, let passText = passwordTextField.text, !passText.isEmpty {
            self.continueButton.loadingIndicator(true);
            
            Auth.auth().signIn(withEmail: usernameText.trim(), password: passText, completion: { (authResult, error) in
                if error == nil {
                    print("Logged in: (\(self.emailTextField.text!))")
                    self.performSegue(withIdentifier: "loggedIn", sender: nil)
                } else {
                    self.errorLabel.text = (error!.localizedDescription)
                    self.continueButton.loadingIndicator(false);
                }
            })
        } else {
            self.errorLabel.text = "Please enter required fields."
        }
    }
    /*
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.ui_scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        ui_scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        ui_scrollView.contentInset = contentInset
    }
     */
}
