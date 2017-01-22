//
//  NewSubViewController.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/21/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class NewSubViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var newIdea: UITextField!
	var ref = FIRDatabase.database().reference()
	var event: String = ""
	var ideaOrPerson: Int = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if(ideaOrPerson == 0) {
			newIdea.placeholder = "Write your idea here"
		} else if(ideaOrPerson == 1) {
			newIdea.placeholder = "Write your specialty here"
		}
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if(textField == self.newIdea) {
			self.onAddIdea(self)
		}
		return false
	}
	
	@IBAction func onAddIdea(_ sender: Any) {
		if(newIdea.text != "") {
			var subType: String = ""
			let user = FIRAuth.auth()?.currentUser
			
			if(ideaOrPerson == 0) {
				subType = "idea"
			} else if(ideaOrPerson == 1) {
				subType = "freelancer"
			}
			
			let childRef = ref.child("subs").child(event).child(subType).childByAutoId()
			let ideaCode = childRef.key
			childRef.child("name").setValue(user?.displayName)
			childRef.child("idea").setValue(newIdea.text)
			childRef.child("creator").setValue(user?.uid)
			
			let userRef = ref.child("users").child((user?.uid)!).child("events").child(event)
			userRef.child(ideaCode).setValue("owner")
			
			let eventRef = ref.child("events").child(event).child(ideaCode)
			eventRef.child((user?.uid)!).child("name").setValue(user?.displayName)
			
			navigationController?.popToRootViewController(animated: true)
		} else {
			let alertController = UIAlertController(title: "Oops!", message: "Enter an idea.", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
