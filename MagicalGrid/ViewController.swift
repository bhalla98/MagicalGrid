//
//  ViewController.swift
//  MagicalGrid
//
//  Created by siddharth bhalla on 4/21/17.
//  Copyright © 2017 sb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let numberPerView = 15
    
    
    var cells = [String: UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let width = view.frame.width / CGFloat(numberPerView)
        
       // let height = view.frame.height / CGFloat(numberPerView)
        
        for j in 0...26{
            for i in 0...numberPerView{
                let cellView = UIView()
                cellView.backgroundColor = randomColor()
                cellView.frame = CGRect(x: CGFloat(i) * width, y: CGFloat(j) * width, width: width, height: width)
                cellView.layer.borderWidth = 1
                cellView.layer.borderColor = UIColor.black.cgColor
                view.addSubview(cellView)
                
                let key = "\(i)|\(j)"
                cells[key] = cellView
            }
        }
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    // keeps a track of selected cell
    var selectedCell: UIView?      /* ? is for optional as it'll keep
                                    the cell value nill initially*/
    
    
    // handles animations of cells that we're touching
    func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
       // print(location)
        
        // -> Efficient way of iterating over cells
        // prints the column of the cell you're touching
        let width = view.frame.width / CGFloat(numberPerView)
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        print(i, j)
        
        // makes the cell which we're touching white
        let key = "\(i)|\(j)"
        
        guard let cellView = cells[key] else {return}
        
        // animates the selected cell back to the original cell view
        if selectedCell != cellView{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                
                self.selectedCell?.layer.transform = CATransform3DIdentity
                
            }, completion: nil)
        }
        
        selectedCell = cellView
        
        // brings the current cell in front
        view.bringSubview(toFront: cellView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            // scales the cell to thrice its original size
                cellView.layer.transform = CATransform3DMakeScale(3, 3, 3)
            
        }, completion: nil)
        
        // if statement animates the cell back to original form once touch is released
        // bouncing back gesture given by Spring damping and velocity
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                cellView.layer.transform = CATransform3DIdentity
                
            }, completion: { (_) in
                
            })
        }
        
        // -> Inefficient way of iterating over many cells
        /*var loopCount = 0
        for subview in view.subviews{
            // makes the cell that we're touching black
            if subview.frame.contains(location){
                subview.backgroundColor = .black
                // print("loopcount:" , loopCount)
            }
            loopCount += 1
        }*/
        
    }   // handlePan() ends
    
    
    
    fileprivate func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    
}

