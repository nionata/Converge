//
//  FormationData.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/21/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

enum formState {
	case loading
	case ready
}

class FormationData: NSObject {
	var myEvent: String?
	var data: [[Formation]] = [[], []]
	var ideaIndex: Int?
	var freelancerIndex: Int?
	var state = formState.loading
	
	init(event: String) {
		super.init()
		myEvent = event
		loadFormation()
	}
	
	func loadFormation() {
		FIRDatabase.database().reference().child("subs").child(myEvent!).observeSingleEvent(of: .value, with: { (snapshot) in
			if let ideas = snapshot.childSnapshot(forPath: "idea").value as? [String: AnyObject] {
				for id in ideas {
					self.data[0].append(Formation(idea: (id.value["idea"]! as! String?)!, owner: (id.value["creator"]! as! String?)!, id: id.key))
				}
			}
			
			if(self.data[0].count != 0) {
				self.ideaIndex = 0;
			}
			
			if let freelancers = snapshot.childSnapshot(forPath: "freelancer").value as? [String: AnyObject] {
				for id in freelancers {
					self.data[1].append(Formation(idea: (id.value["idea"]! as! String?)!, owner: (id.value["creator"]! as! String?)!, id: id.key))
				}
			}
			
			if(self.data[1].count != 0) {
				self.freelancerIndex = 0;
			}
			
			self.state = formState.ready
		})
	}
	
	func nextIdea() -> String {
		return data[0][ideaIndex!].idea
	}
	
	func nextIdea(toggle: Bool) -> String {
		if(ideaIndex == data[0].count - 1) {
			ideaIndex = 0
		} else {
			ideaIndex = ideaIndex! + 1
		}
		
		return data[0][ideaIndex!].idea
	}
	
	func nextFreelancer() -> String {
		return data[1][freelancerIndex!].idea
	}
	
	func nextFreelancer(toggle: Bool) -> String {
		if(freelancerIndex == data[1].count - 1) {
			freelancerIndex = 0
		} else {
			freelancerIndex = freelancerIndex! + 1
		}
		
		return data[1][freelancerIndex!].idea
	}
}
