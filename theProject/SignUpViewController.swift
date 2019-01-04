import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: Actions
    @IBAction func continueButtonPressed(_ sender: Any) {
        attemptSignIn()
    }
    
    func attemptSignIn() {
        // Attempts to create user using email & password
        // Success -> segue
        
        if let nameText = nameTextField.text, !nameText.isEmpty, let usernameText = usernameTextField.text, !usernameText.isEmpty,
            let emailText = emailTextField.text, !emailText.isEmpty, let passText = passwordTextField.text, !passText.isEmpty {
            
            self.continueButton.loadingIndicator(true)
            
            // Check if username is already in use.
            
            Auth.auth().createUser(withEmail: emailText.trim(), password: passText) { (authResult, error) in
                if error == nil {
                    print("User (\(usernameText)) created.")
                    
                    // Add username
                    let ref: DatabaseReference = Database.database().reference()
                    let user = Auth.auth().currentUser!
                    ref.child("users").child(user.uid).setValue(["displayName": nameText.trim(), "username": usernameText.trim().lowercased()])
                    
                    self.performSegue(withIdentifier: "signedUp", sender: nil)
                } else {
                    self.continueButton.loadingIndicator(false)
                    self.errorLabel.text = error!.localizedDescription
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        nameTextField.setBottomBorder()
        usernameTextField.setBottomBorder()
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        
        continueButton.applyDesign()
        imageOutlet.maskCircle(anyImage: UIImage(named: "defaultProfileImage.jpg")!)
        
        self.backgroundImageOutlet.image = UIImage(named: "escheresque.png")!.resizableImage(withCapInsets: .zero)
        self.errorLabel.text = " "
        self.errorLabel.numberOfLines = 0
        self.passwordTextField.returnKeyType = UIReturnKeyType.go
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        attemptSignIn()
        return true
    }
}
