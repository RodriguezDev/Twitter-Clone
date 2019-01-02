import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        // Attempts user log in using email & password.
        // Success -> segue
        
        if usernameTextField.text != nil && passwordTextField.text != nil {
            Auth.auth().signIn(withEmail: usernameTextField.text!.trim(), password: passwordTextField.text!, completion: { (authResult, error) in
                if error == nil {
                    print("Logged in: (\(self.usernameTextField.text!))")
                    self.performSegue(withIdentifier: "loggedIn", sender: nil)
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.applyDesign()
        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
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
}

extension UITextField
{
    func setBottomBorder()
    {
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
