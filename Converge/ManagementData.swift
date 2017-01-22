//
//  ManagementData.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/22/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

enum manState {
	case loading
	case ready
}

class ManagementData: NSObject {
	
	var ref = FIRDatabase.database().reference()
	var myEvent: String?
	var teams: [Team] = []
	var myData: FormationData
	var state = manState.loading
	var test = ""
	
	init(event: String, formData: FormationData) {
		myEvent = event
		myData = formData
		
		super.init()
		
		loadData()
	}
	
	func loadData() {
		let childRef = ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("events").child(myEvent!)
		childRef.observeSingleEvent(of: .value, with: { (snapshot) in
			let dict = snapshot.value as? [String: AnyObject]
			
			for id in dict! {
				let ideaKey = id.key
				
				var newForm: Formation = Formation(idea: "", owner: "", id: "")
				var newMembers: [Member] = []
				var newRequests: [inRequest] = []
				
				for form: Formation in self.myData.data[0] {
					if(form.id == ideaKey) {
						newForm = form
					}
				}
				
				for form: Formation in self.myData.data[1] {
					if(form.id == ideaKey) {
						newForm = form
					}
				}
				
				if let mems = snapshot.childSnapshot(forPath: ideaKey).childSnapshot(forPath: "members").value as? [String: AnyObject] {
					for memId in mems {
						newMembers.append(Member(name: (memId.value["name"]! as! String?)!, id: memId.key, msg: (memId.value["message"]! as! String?)!))
					}
				}
				
				if let reqs = snapshot.childSnapshot(forPath: ideaKey).childSnapshot(forPath: "requests").value as? [String: AnyObject] {
					for memId in reqs {
						newRequests.append(inRequest(name: (memId.value["name"] as? String)!, id: memId.key, msg: (memId.value["message"] as? String)!))
					}
				}
				
				self.teams.append(Team(meta: newForm, members: newMembers, requests: newRequests))
				
				self.state = manState.ready
			}
		})
	}

}
