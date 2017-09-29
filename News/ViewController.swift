//
//  ViewController.swift
//  News
//
//  Created by Sanchit Mittal on 14/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveToNextController), userInfo: nil,repeats: false)
    }
    
    func moveToNextController() {
        let navigationController = storyboard?.instantiateViewController(withIdentifier: "SourcesViewNavigationControllerIdentifier") as! UINavigationController
        self.present(navigationController, animated: true, completion: nil)
    }
}


