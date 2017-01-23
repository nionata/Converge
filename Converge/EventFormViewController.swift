//
//  EventFormViewController.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/21/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EventFormViewController: UIViewController {
	
	var ref = FIRDatabase.database().reference()
	var event: String = ""
	@IBOutlet weak var segControl: UISegmentedControl!
	@IBOutlet weak var insertField: UITextView!
	var myFormData: FormationData!

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.topViewController?.title = event
		myFormData = FormationData(event: event)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		onSegControl(segControl)
		let vc = self.tabBarController?.viewControllers?[1] as? ManagementViewController
		vc?.myFormData = myFormData
		vc?.event = event
	}
	
	@IBAction func onNext(_ sender: Any) {
		if(segControl.selectedSegmentIndex == 0) {
			if (myFormData.ideaIndex != nil) {
				insertField.text = myFormData.nextIdea(toggle: true)
			} else {
				let alertController = UIAlertController(title: "Oops!", message: "There are no ideas at this time. Come back later or add your own!", preferredStyle: .alert)
				let addIdea = UIAlertAction(title: "Add Idea", style: .default, handler: { (UIAlertAction) in
					self.performSegue(withIdentifier: "toAddIdea", sender: self)
				})
				let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
				alertController.addAction(addIdea)
				alertController.addAction(defaultAction)
				self.present(alertController, animated: true, completion: nil)
			}
		} else if(segControl.selectedSegmentIndex == 1) {
			if (myFormData.freelancerIndex != nil) {
				insertField.text = myFormData.nextFreelancer(toggle: true)
			} else {
				let alertController = UIAlertController(title: "Oops!", message: "There are no freelancers at this time. Come back later or add yourself!", preferredStyle: .alert)
				let addIdea = UIAlertAction(title: "Add Yourself", style: .default, handler: { (UIAlertAction) in
					self.performSegue(withIdentifier: "toAddIdea", sender: self)
				})
				let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
				alertController.addAction(addIdea)
				alertController.addAction(defaultAction)
				self.present(alertController, animated: true, completion: nil)
			}
		}
	}
	
	@IBAction func onConnect(_ sender: Any) {
		var index: Int
		var text: String = ""
		
		if(segControl.selectedSegmentIndex == 0) {
			index = self.myFormData.ideaIndex!
		} else {
			index = self.myFormData.freelancerIndex!
		}
		
		let alert = UIAlertController(title: "Poster Has Been Notified", message: "Add a few words below about your experience or ideas", preferredStyle: .alert)
		alert.addTextField { (textField) in
			textField.text = ""
		}
		let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
			let textField = alert?.textFields![0]
			text = (textField?.text)!
			//self.ref.child("events").child(self.myFormData.myEvent!).child(self.myFormData.data[self.segControl.selectedSegmentIndex][index].id).child("pending").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(textField?.text)
			let newRef = self.ref.child("users").child(self.myFormData.data[self.segControl.selectedSegmentIndex][index].owner).child("events").child(self.myFormData.myEvent!).child(self.myFormData.data[self.segControl.selectedSegmentIndex][index].id).child("requests").child((FIRAuth.auth()?.currentUser?.uid)!)
			newRef.child("message").setValue(textField?.text)
			newRef.child("name").setValue(FIRAuth.auth()?.currentUser?.displayName)
		}))
		alert.addAction(action)
		self.present(alert, animated: true, completion: nil)
		
		Session.shared.authentication = Authentication.apiKey("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")
		let personalization = Personalization(recipients: (FIRAuth.auth()?.currentUser?.email)!)
		let plainText = Content(contentType: ContentType.plainText, value: "A user wanted to work with you. Here is some additional info: \(text)")
		let htmlText = Content(contentType: ContentType.htmlText, value: "<h1>Hello World</h1>")
		let email = Email(
			personalizations: [personalization],
			from: Address("n.ionata129@gmail.com"),
			content: [plainText, htmlText],
			subject: "New Connection On Converge!"
		)
		do {
			try Session.shared.send(request: email)
		} catch {
			print(error)
		}
		
	}
	
	@IBAction func onSegControl(_ sender: UISegmentedControl) {
		if(sender.selectedSegmentIndex == 0) {
			if (myFormData.ideaIndex != nil) {
				insertField.text = myFormData.nextIdea()
			} else {
				let alertController = UIAlertController(title: "Oops!", message: "There are no ideas at this time. Come back later or add your own!", preferredStyle: .alert)
				let addIdea = UIAlertAction(title: "Add Idea", style: .default, handler: { (UIAlertAction) in
					self.performSegue(withIdentifier: "toAddIdea", sender: self)
				})
				let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
				alertController.addAction(addIdea)
				alertController.addAction(defaultAction)
				self.present(alertController, animated: true, completion: nil)
				insertField.text = ""
			}
		} else if(sender.selectedSegmentIndex == 1) {
			if (myFormData.freelancerIndex != nil) {
				insertField.text = myFormData.nextFreelancer()
			} else {
				let alertController = UIAlertController(title: "Oops!", message: "There are no freelancers at this time. Come back later or add yourself!", preferredStyle: .alert)
				let addIdea = UIAlertAction(title: "Add Yourself", style: .default, handler: { (UIAlertAction) in
					self.performSegue(withIdentifier: "toAddIdea", sender: self)
				})
				let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
				alertController.addAction(addIdea)
				alertController.addAction(defaultAction)
				self.present(alertController, animated: true, completion: nil)
				insertField.text = ""
			}
		}
	}
	
	func addIdea() {
		self.performSegue(withIdentifier: "toAddIdea", sender: self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "toAddIdea") {
			let dest = segue.destination as? NewSubViewController
			dest?.event = self.event
			dest?.ideaOrPerson = segControl.selectedSegmentIndex
		}
	}
}
