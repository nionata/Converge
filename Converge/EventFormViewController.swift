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
	
	var event: String = ""
	@IBOutlet weak var segControl: UISegmentedControl!
	@IBOutlet weak var insertField: UITextView!
	@IBOutlet weak var button: UIButton!
	var myFormData: FormationData!

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.topViewController?.title = event
		myFormData = FormationData(event: event)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		onSegControl(segControl)
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
		
		if(segControl.selectedSegmentIndex == 0) {
			index = self.myFormData.ideaIndex!
		} else {
			index = self.myFormData.freelancerIndex!
		}
		
		let alert = UIAlertController(title: "Thank You", message: "We will notify the original poster immedietly about your interest. Please say a few words below about any relevant work or anything else.", preferredStyle: .alert)
		alert.addTextField { (textField) in
			textField.text = ""
		}
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
			let textField = alert?.textFields![0]
			FIRDatabase.database().reference().child("events").child(self.myFormData.myEvent!).child(self.myFormData.data[self.segControl.selectedSegmentIndex][index].id).child("pending").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(textField?.text)
			FIRDatabase.database().reference().child("users").child(FIRAuth.auth()?.currentUser?.uid).child("events").child(self.myFormData.myEvent).child("Outward requests")
		}))
		self.present(alert, animated: true, completion: nil)
		
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
			
			button.titleLabel?.text = "Add Your Idea"
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
			
			button.titleLabel?.text = "Add Yourself"
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
