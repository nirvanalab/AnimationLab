//
//  ViewController.swift
//  Week4Lab
//
//  Created by Nirvana on 10/3/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func onTrayPan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: sender.view)
        
        switch sender.state {
            case .began:
                break
            case .changed:
                trayView.center = CGPoint(x: trayView.center.x + translation.x, y: trayView.center.y+translation.y)
                break
            case .ended:
                break
            default:
                break
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }


}

