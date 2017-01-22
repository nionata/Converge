//
//  ManagementViewController.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/22/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit

class ManagementViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
	
	var event: String = ""
	var myFormData: FormationData!
	var myManage: ManagementData!
	@IBOutlet weak var table: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		myManage = ManagementData(event: event, formData: myFormData)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		if(myManage.state == manState.loading) {
			let deadlineTime = DispatchTime.now() + .seconds(1)
			DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
				self.viewDidAppear(true)
			})
		} else {
			self.table.reloadData()
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return myManage.teams[0].count + myManage.teams[1].count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2//myManage.teams[1][section].members.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = "Hi"
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return myManage.teams[1][section].meta.idea
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
