//
//  PopupViewController.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/12.
//

import UIKit

class PopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func okButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
