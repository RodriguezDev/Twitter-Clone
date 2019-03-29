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
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        */
    }
    
    /*
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        // Check if user is already logged in.
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("User \(user.email!) logged in.")
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
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
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
}
