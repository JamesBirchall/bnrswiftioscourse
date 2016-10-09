//
//  ViewController.swift
//  WorldTrotter
//
//  Created by James Birchall on 09/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLayoutSubviews() {
        
        let xPosition = self.view.frame.midX - 50
        let yPosition = self.view.frame.midY - 75
        
        let firstFrame = CGRect(x: xPosition, y: yPosition, width: 100, height: 150)
        let firstView = UIView(frame: firstFrame)
        
        firstView.backgroundColor = UIColor.blue
        view.addSubview(firstView)
        
        // let 2nd image be in right bottom corner
        // changed to firstView
//        let x2Position = self.view.frame.maxX - 50
//        let y2Position = self.view.frame.maxY - 50
        
        // use bounds property as thats the drawable area of the view containing 2ndView
        // this is because frame is still superview which is the whole screen
        let x2Position = firstView.bounds.maxX - 50
        let y2Position = firstView.bounds.maxY - 50
        
        let secondFrame = CGRect(x: x2Position, y: y2Position, width: 50, height: 50)
        let secondView = UIView(frame: secondFrame)
        
        secondView.backgroundColor = UIColor.green
        //view.addSubview(secondView)
        firstView.addSubview(secondView)
    }

}

