//
//  DrawView.swift
//  TouchTracker
//
//  Created by James Birchall on 09/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    
    // MARK: - @IBInspectables
    
    @IBInspectable var finishedLineColour: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColour: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Inits
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.isMultipleTouchEnabled = true
    }
    
    // MARK: - UIView Overrides
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        finishedLineColour.setStroke()
        
        for line in finishedLines {
            strokeLine(line: line)
        }
        
        for (_,line) in currentLines {
            // make curent drawing line in red
            currentLineColour.setStroke()
            strokeLine(line: line)
        }
    }
    
    // MARK: - Touch Handler Overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
//        let touch = touches.first!  // has to be at least one touch for function!
//        let location = touch.location(in: self)
//        currentLine = Line(begin: location, end: location)  // inititally set to start point

        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            // create pointer reference and store line values
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()   // marks view as needing redraw
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
//        let touch = touches.first!
//        let location = touch.location(in: self)
//        currentLine?.end = location

        for touch in touches {
            let key = NSValue(nonretainedObject: touch) // pull out right reference line
            currentLines[key]?.end = touch.location(in: self)   // update end point
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
//        if var line = currentLine {
//            let touch = touches.first!
//            let location = touch.location(in: self)
//            line.end = location
//            
//            finishedLines.append(line)
//        }
//        
//        currentLine = nil   // make sure to reset currentLine

        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        currentLines.removeAll()    // get rid of any temp in progress lines
        
        setNeedsDisplay()
    }
    
    
    // MARK: - Custom Stroke Functions
    
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        // drawing routines
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
}
