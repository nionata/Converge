//
//  ViewController.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/21/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var newEmail: UITextField!
	@IBOutlet weak var newPassword: UITextField!
	
	override func viewDidLoad() {
		self.navigationController?.navigationBar.isHidden = true
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if(textField == self.newEmail) {
			self.newPassword.becomeFirstResponder()
		} else if(textField == self.newPassword) {
			onSignIn(self)
		}
		return false
	}

	@IBAction func onSignIn(_ sender: Any) {
		if(newEmail.text != "" && newPassword.text != "") {
			FIRAuth.auth()?.signIn(withEmail: self.newEmail.text!, password: self.newPassword.text!, completion: { (user, error) in
				if(error == nil) {
					self.newEmail.text = ""
					self.newPassword.text = ""
					self.newPassword.resignFirstResponder()
					self.performSegue(withIdentifier: "toHomeFromIn", sender: self)
				} else {
					let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
					let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
					alertController.addAction(defaultAction)
					self.present(alertController, animated: true, completion: nil)
				}
			})
		} else {
			let alertController = UIAlertController(title: "Oops!", message: "Enter an email and password", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

