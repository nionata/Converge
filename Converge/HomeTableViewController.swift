//
//  HomeTableViewController.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/21/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeTableViewController: UITableViewController {
	
	@IBOutlet var table: UITableView!
	var ref = FIRDatabase.database().reference()
	var events: [String] = []
	var currentSegue = 0

    override func viewDidLoad() {
        super.viewDidLoad()
		loadEvents()
    }

	override func viewDidAppear(_ animated: Bool) {
		FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
			if user == nil {
				self.performSegue(withIdentifier: "toSignIn", sender: self)
			}
		}
		
		self.table.reloadData()
	}
	
	func loadEvents() {
		let usersRef = ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("events")
		usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject] {
				for key in dict {
					self.events.append(key.key)
				}
			}
			
			if(self.events.count == 0) {
				let alertController = UIAlertController(title: "Welcome!", message: "You are not joined or created an event. Start by tapping the top right", preferredStyle: .alert)
				let newAction = UIAlertAction(title: "Get Started", style: .default, handler: { (alert) in
					self.performSegue(withIdentifier: "toCreateAccount", sender: self)
				})
				let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
				alertController.addAction(defaultAction)
				alertController.addAction(newAction)
				self.present(alertController, animated: true, completion: nil)
			}
			
			self.table.reloadData()
		})
	}
	
	@IBAction func onLogOut(_ sender: Any) {
		try! FIRAuth.auth()?.signOut()
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = events[indexPath.row]
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentSegue = indexPath.row
		self.performSegue(withIdentifier: "toEventTabs", sender: self)
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "toEventTabs") {
			let newView = segue.destination as! UITabBarController
			let memView = newView.viewControllers?.first as! EventFormViewController
			memView.event = events[currentSegue]
			currentSegue = 0
		}
    }


}
