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
	var teams: [[Team]] = [[], []]
	var myData: FormationData
	var state = manState.loading
	
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
				
				for form: Formation in self.myData.data[0] {
					if(form.id == ideaKey) {
						self.teams[1].append(Team(meta: form, members: []))
						
					}
					
					/*if(id.value["requests"] != nil) {
						self.teams[0].append(Team)
					}*/
				}
				
				for form: Formation in self.myData.data[1] {
					if(form.id == ideaKey) {
						self.teams[1].append(Team(meta: form, members: []))
					}
				}
				
				self.state = manState.ready
			}
		})
	}

}
