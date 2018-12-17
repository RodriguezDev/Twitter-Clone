import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: Actions
    @IBAction func continueButtonPressed(_ sender: Any) {
        // Attempts to create user using email & password
        // Success -> segue
        // TODO: add error messages / warnings, check if username is taken.
        
        if emailTextField.text != nil && passwordTextField.text != nil && usernameTextField.text != nil {
            Auth.auth().createUser(withEmail: emailTextField.text!.trim(), password: passwordTextField.text!) { (authResult, error) in
                if error == nil {
                    print("User (\(self.emailTextField.text!)) created.")
                    
                    // Add username
                    let ref: DatabaseReference = Database.database().reference()
                    let user = Auth.auth().currentUser!
                    ref.child("users").child(user.uid).setValue(["username": self.usernameTextField.text!])
                    
                    self.performSegue(withIdentifier: "signedUp", sender: nil)
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.setBottomBorder()
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        continueButton.applyDesign()
    }
}
