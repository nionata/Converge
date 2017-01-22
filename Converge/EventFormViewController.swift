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

struct Formation {
	var idea: String?
	var owner: String?
	var id: String?
}

class EventFormViewController: UIViewController {
	
	var ref = FIRDatabase.database().reference()
	var event: String = ""
	var formationData: [[Formation]] = [[]]
	@IBOutlet weak var segControl: UISegmentedControl!
	@IBOutlet weak var insertField: UITextView!
	@IBOutlet weak var button: UIButton!
	var ideaIndex: Int = 0
	var freelancerIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.topViewController?.title = event
		loadFormation()
	}
	
	func loadData(whichOne: Int, index: Int) {
		insertField.text = formationData[whichOne][index].idea
	}
	
	func loadFormation() {
		ref.child("subs").child(event).observeSingleEvent(of: .value, with: { (snapshot) in
			if let ideas = snapshot.childSnapshot(forPath: "idea").value as? [String: AnyObject] {
				for id in ideas {
					self.formationData[0].append(Formation(idea: id.value["idea"]! as! String?, owner: id.value["creator"]! as! String?, id: id.key))
				}
			}
			
			if let freelancers = snapshot.childSnapshot(forPath: "freelancer").value as? [String: AnyObject] {
				for id in freelancers {
					self.formationData[1].append(Formation(idea: id.value["idea"]! as! String?, owner: id.value["creator"]! as! String?, id: id.key))
				}
			}
			
			if(self.formationData[0].count == 0) {
				let alertController = UIAlertController(title: "Oops!", message: "There are no ideas at this time. Come back later or add your own!", preferredStyle: .alert)
				let addIdea = UIAlertAction(title: "Add Idea", style: .default, handler: { (UIAlertAction) in
					self.performSegue(withIdentifier: "toAddIdea", sender: self)
				})
				let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
				alertController.addAction(addIdea)
				alertController.addAction(defaultAction)
				self.present(alertController, animated: true, completion: nil)
				return
			} else if(self.formationData[1].count == 0) {
				let alertController = UIAlertController(title: "Oops!", message: "There are no freelancers at this time. Come back later or add yourself!", preferredStyle: .alert)
				let addFreelancer = UIAlertAction(title: "Add Yourself", style: .default, handler: { (UIAlertAction) in
					self.performSegue(withIdentifier: "toAddIdea", sender: self)
				})
				let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
				alertController.addAction(addFreelancer)
				alertController.addAction(defaultAction)
				self.present(alertController, animated: true, completion: nil)
				return
			}
			
			self.loadData(whichOne: 0, index: self.ideaIndex)
		})
	}
	
	@IBAction func onNext(_ sender: Any) {
		if(segControl.selectedSegmentIndex == 0) {
			if(ideaIndex == formationData[0].count - 1) {
				ideaIndex = 0
			} else {
				ideaIndex = ideaIndex + 1
			}
		
			loadData(whichOne: 0, index: ideaIndex)
		} else if(segControl.selectedSegmentIndex == 1) {
			if(freelancerIndex == formationData[1].count - 1) {
				freelancerIndex = 0
			} else {
				freelancerIndex = freelancerIndex + 1
			}
		
			loadData(whichOne: 1, index: freelancerIndex)
		}
	}
	
	@IBAction func onConnect(_ sender: Any) {
	}
	
	
	@IBAction func onSegControl(_ sender: UISegmentedControl) {
		if(sender.selectedSegmentIndex == 0) {
			loadData(whichOne: 0, index: ideaIndex)
			button.titleLabel?.text = "Add Your Idea"
		} else if(sender.selectedSegmentIndex == 1) {
			loadData(whichOne: 1, index: freelancerIndex)
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
