//
//  ViewController.swift
//  Foursquare
//
//  Created by Melik Demiray on 12.11.2023.
//

import UIKit
import ParseCore

class SignUpVC: UIViewController {

    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!

    var nameArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func signInButton(_ sender: Any) {

        if userNameTxt.text != "" && passwordTxt.text != "" {

            PFUser.logInWithUsername(inBackground: userNameTxt.text!, password: passwordTxt.text!) { user, error in
                if let err = error {

                    self.makeAlert(title: "Error", message: err.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }
        else {
            self.makeAlert(title: "Error", message: "Username/Password?")
        }
    }

    @IBAction func signUpButton(_ sender: Any) {

        if userNameTxt.text != "" && passwordTxt.text != "" {

            let user = PFUser()

            user.username = userNameTxt.text!
            user.password = passwordTxt.text!

            user.signUpInBackground { success, error in
                if let err = error {
                    self.makeAlert(title: "Error", message: err.localizedDescription)

                }
                else {
                    self.makeAlert(title: "Success", message: "User Created")
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }
        else {
            self.makeAlert(title: "Error", message: "Username/Password?")
        }
    }

    func makeAlert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)

        alert.addAction(okButton)

        self.present(alert, animated: true, completion: nil)
    }


}

