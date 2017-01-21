//
//  NewEventViewController.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/21/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class NewEventViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var newEvent: UITextField!
	var ref = FIRDatabase.database().reference()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//navigationController?.navigationBar.barTintColor = button.tintColor
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if(textField == self.newEvent) {
			self.onAdd(self)
		}
		return false
	}

	@IBAction func onAdd(_ sender: Any) {
		if(newEvent.text != "") {
			ref.child("events").child(newEvent.text!).setValue("true")
			ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("events").child(newEvent.text!).setValue("true")
			let nav = self.navigationController?.viewControllers.first as! HomeTableViewController
			nav.events.append(newEvent.text!)
			navigationController?.popToRootViewController(animated: true)
		} else {
			let alertController = UIAlertController(title: "Oops!", message: "Enter a event name.", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
		}
	
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
