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
    
    @IBOutlet weak var trayArrow: UIImageView!
    
    var trayOpenCenter:CGPoint = CGPoint.zero
    var trayCloseCenter:CGPoint = CGPoint.zero
    var newlyCreatedFace: UIImageView!
    
    var currentTrayState:TrayState = .Open {
        didSet {
            moveTray(currentState: currentTrayState)
        }
    }
    
    var previousState:TrayState = .Open
    
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
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.image = imageView.image
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            //add pan gesture to newly created face
            let smileyPan = UIPanGestureRecognizer(target: self, action: #selector(onIndividualEmoticonPan(_:)))
            smileyPan.delegate = self
            newlyCreatedFace.addGestureRecognizer(smileyPan)
            
            //add pinch gesture to newly created face
            let smileyPinch = UIPinchGestureRecognizer(target: self, action: #selector(onIndividualEmoticonPinch(_:)))
            smileyPinch.delegate = self
            newlyCreatedFace.addGestureRecognizer(smileyPinch)
            
            let smileyDoubleTap = UITapGestureRecognizer(target: self, action: #selector(onEmoticonTap(_:)))
            smileyDoubleTap.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(smileyDoubleTap)
            
            //add rotate gesture to newly created face
            let smileyRotate = UIRotationGestureRecognizer(target: self, action: #selector(onIndividualEmoticonRotate(_:)))
            smileyRotate.delegate = self
            newlyCreatedFace.addGestureRecognizer(smileyRotate)
            
            
            
            //scale the newlyCreatedFace to 1.5x
            UIView.animate(withDuration: 0.5, animations: {
                let scaleTransform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
                self.newlyCreatedFace.transform = scaleTransform
            })
            
            
            
            break
        case .changed:
            if let view = sender.view {
                let translation = sender.translation(in: view)
                newlyCreatedFace.center = CGPoint(x: newlyCreatedFace.center.x + translation.x, y: newlyCreatedFace.center.y+translation.y)
            }
            break
        case .ended:
            //scale the newlyCreatedFace to 1x
            UIView.animate(withDuration: 0.5, animations: {
                let scaleTransform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.newlyCreatedFace.transform = scaleTransform
            })
            break
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, in: self.view)

    }
    
    func onIndividualEmoticonPan(_ sender:UIPanGestureRecognizer ) {
        
        var originalPostion:CGPoint = CGPoint.zero
        switch sender.state {
        case .began:
            originalPostion = (sender.view?.center)!
            break
        case .changed:
            if let view = sender.view {
                let translation = sender.translation(in: sender.view)
                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y+translation.y)
            }
            break
        case .ended:
            
            //check if emoticon intersects with the tray view
//            if let view = sender.view {
//                if view.frame.intersects(self.trayView.frame) {
//                    view.center = originalPostion
//                }
//            }
            break
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
        
    }
    
    func onIndividualEmoticonPinch(_ sender:UIPinchGestureRecognizer ) {
        
        switch sender.state {
        case .began:
            break
        case .changed:
            if let view = sender.view {
                view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1
            }
            
            break
        case .ended:
            
            break
        default:
            break
        }
    }
    
    func onIndividualEmoticonRotate(_ sender:UIRotationGestureRecognizer) {
        
        switch sender.state {
        case .began:
            break
        case .changed:
            if let view = sender.view {
                view.transform = view.transform.rotated(by: sender.rotation)
                sender.rotation = 0
            }
            break
        case .ended:
            
            break
        default:
            break
        }

    }
    
    func onEmoticonTap(_ sender:UITapGestureRecognizer) {
        if let view = sender.view {
            UIView.animate(withDuration: 0.5, animations: {
                view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { _ in
                view.removeFromSuperview()

            })
        }
    }
    
    
    func moveTray(currentState:TrayState) {
        var trayPosition = CGPoint.zero
        switch currentState {
        case .Open:
            trayPosition = trayOpenCenter
            break
        case .Closed:
            trayPosition = trayCloseCenter
            break
            
        }
        
        if previousState != currentState {
             self.trayArrow.transform =  self.trayArrow.transform.rotated(by: 3.14)
        }
        
        previousState = currentState;
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:
            0.3, initialSpringVelocity: 1.0, options: [], animations: {

                self.trayView.center = trayPosition
                
                
        }) { _ in
           
        }
    }

}


extension ViewController: UIGestureRecognizerDelegate {
    
    //Asks the delegate if two gesture recognizers should be allowed to recognize gestures simultaneously.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

