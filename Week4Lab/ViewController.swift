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
    var newlyCreatedFace: UIImageView!
    
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
                if let view = sender.view {
                    let translation = sender.translation(in: sender.view)
                    view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y+translation.y)
                }
               
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
    
    
    @IBAction func onEmoticonPan(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            // Gesture recognizers know the view they are attached to
            let imageView = sender.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView.init(frame: (sender.view?.frame)!)
            newlyCreatedFace.image = imageView.image
            
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            break
        case .changed:
            if let view = sender.view {
                let translation = sender.translation(in: view)
                newlyCreatedFace.center = CGPoint(x: newlyCreatedFace.center.x + translation.x, y: newlyCreatedFace.center.y+translation.y)
            }
            break
        case .ended:
            break
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, in: self.view)

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

