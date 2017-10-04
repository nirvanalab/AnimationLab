//
//  ViewController.swift
//  Week4Lab
//
//  Created by Nirvana on 10/3/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit

enum TrayState {
    case Open
    case Closed
}

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var trayOpenCenter:CGPoint = CGPoint.zero
    var trayCloseCenter:CGPoint = CGPoint.zero
    
    var currentTrayState:TrayState = .Open {
        didSet {
            moveTray(position: currentTrayState)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize the tray open center
        trayOpenCenter = CGPoint(x: trayView.frame.midX, y: trayView.frame.midY)
        //initialize the tray close center
        trayCloseCenter = CGPoint(x: trayView.frame.midX, y: trayView.frame.maxY + 75)
        
    }


    @IBAction func onTrayPan(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
            case .began:
                break
            case .changed:
                let translation = sender.translation(in: sender.view)
                trayView.center = CGPoint(x: trayView.center.x + translation.x, y: trayView.center.y+translation.y)
                break
            case .ended:
                let velocity = sender.velocity(in: sender.view)
                print (velocity.y)
                currentTrayState = (velocity.y <= 0) ? TrayState.Open : TrayState.Closed
                
                break
            default:
                break
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
    @IBAction func onTapGesture(_ sender: UITapGestureRecognizer) {
        
        currentTrayState = currentTrayState == .Open ? .Closed : .Open
    }
    
    func moveTray(position:TrayState) {
        var trayPosition = CGPoint.zero
        switch position {
        case .Open:
            trayPosition = trayOpenCenter
            break
        case .Closed:
            trayPosition = trayCloseCenter
            break
            
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:
            0.3, initialSpringVelocity: 1.0, options: [], animations: {
                
                self.trayView.center = trayPosition
                
        }) { _ in
            
        }
    }

}

