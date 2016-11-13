//
//  ViewController.swift
//  TouchTracker
//
//  Created by James Birchall on 09/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentLineColour: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Swipe Gesture 
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 3
        view.addGestureRecognizer(swipeUp)
    }
    
    func swipe() {
        let colourPicker = ColourPickerViewController()
        colourPicker.modalPresentationStyle = .overCurrentContext
        
        colourPicker.viewControllerCallingPicker = self
        
        present(colourPicker, animated: true, completion: {
//            let drawView = self.view as! DrawView
//            drawView.selectLineIndex = nil
//            drawView.currentLines.removeAll(keepingCapacity: false)
//            //drawView.lineThickness = 0
//            drawView.setNeedsDisplay()            
        })
    }
    
    func colourPanelDismissedWithNewColour(colour: UIColor) {
        let drawView = view as! DrawView
        drawView.currentLineSetColour = colour
    }
}

