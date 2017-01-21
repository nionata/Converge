//
//  EventFormViewController.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/21/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit

class EventFormViewController: UIViewController {
	
	var event: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.topViewController?.title = event
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
