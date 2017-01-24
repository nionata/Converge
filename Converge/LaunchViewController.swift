//
//  LaunchViewController.swift
//  Converge
//
//  Created by Nicholas Ionata on 1/23/17.
//  Copyright © 2017 Nicholas Ionata. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchViewController: UIViewController {

	
	@IBOutlet weak var imageWell: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		imageWell.animationImages = getImages(inName: "load")
		imageWell.animationDuration = 1.1
		imageWell.startAnimating()
		
		
		let deadlineTime = DispatchTime.now() + .seconds(1)
		DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
			FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
				self.imageWell.stopAnimating()
				if user != nil {
					self.performSegue(withIdentifier: "toHome", sender: self)
				} else {
					self.performSegue(withIdentifier: "toIn", sender: self)
				}
			}
		})
    }
	
	func getImages(inName: String) -> [UIImage] {
		
		let nums = [0,1,2,3,4,5,6,7,8]
		
		var newArray: [UIImage] = []
		
		for nummy in nums {
			if let img = UIImage(named: "\(inName)\(nummy)") {
				newArray.append(img)
			}
		}
		
		return newArray
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	}

}
