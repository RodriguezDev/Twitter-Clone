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
        // TODO: integrate username, add error messages / warnings
        
        if emailTextField.text != nil && passwordTextField.text != nil {
            Auth.auth().createUser(withEmail: emailTextField.text!.trim(), password: passwordTextField.text!) { (authResult, error) in
                if error == nil {
                    print("User (\(self.emailTextField.text!)) created.")
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
