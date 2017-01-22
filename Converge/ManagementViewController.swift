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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		<#code#>
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		<#code#>
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		<#code#>
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
