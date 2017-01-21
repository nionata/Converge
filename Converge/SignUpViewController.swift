//
//  SignUpViewController.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/21/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var newName: UITextField!
	@IBOutlet weak var newEmail: UITextField!
	@IBOutlet weak var newPassword: UITextField!
	var ref = FIRDatabase.database().reference()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if(textField == self.newName) {
			self.newEmail.becomeFirstResponder()
	    } else if(textField == self.newEmail) {
			self.newPassword.becomeFirstResponder()
		} else if(textField == self.newPassword) {
			self.onSignUp(self)
		}
		return false
	}

	@IBAction func onSignUp(_ sender: Any) {
		if(newName.text != "" && newEmail.text != "" && newPassword.text != "") {
			FIRAuth.auth()?.createUser(withEmail: self.newEmail.text!, password: self.newPassword.text!, completion: { (user, error) in
				if(error == nil) {
					let changeRequest = user?.profileChangeRequest()
					changeRequest?.displayName = self.newName.text
					changeRequest?.commitChanges(completion: { (error2) in
						if(error2 == nil) {
							let userRef = self.ref.child("users").child((user?.uid)!)
							userRef.child("name").setValue(user?.displayName)
							userRef.child("email").setValue(user?.email)
							self.newName.text = ""
							self.newEmail.text = ""
							self.newPassword.text = ""
							self.newPassword.resignFirstResponder()
							
							self.performSegue(withIdentifier: "toHomeFromUp", sender: self)
						} else {
							let alertController = UIAlertController(title: "Oops", message: error2?.localizedDescription, preferredStyle: .alert)
							let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
							alertController.addAction(defaultAction)
							self.present(alertController, animated: true, completion: nil)
						}
					})
				} else {
					let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
					let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
					alertController.addAction(defaultAction)
					self.present(alertController, animated: true, completion: nil)
				}
			})
		}  else {
			let alertController = UIAlertController(title: "Oops", message: "Enter a name, email, and password.", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
