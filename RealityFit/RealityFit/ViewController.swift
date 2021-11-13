//
//  ViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 13/11/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultStyle()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var levelCell: UIView!
    func applyDefaultStyle(){
        levelCell.layer.cornerRadius = 10
    }
}

