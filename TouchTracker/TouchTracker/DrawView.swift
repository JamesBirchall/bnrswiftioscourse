//
//  DrawView.swift
//  TouchTracker
//
//  Created by James Birchall on 09/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var currentLine: Line?
    var finishedLines = [Line]()
    
    // MARK: - UIView Overrides
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        UIColor.black.setStroke()
        
        for line in finishedLines {
            strokeLine(line: line)
        }
        
        if let line = currentLine {
            // make curent drawing line in red
            UIColor.red.setStroke()
            strokeLine(line: line)
        }
    }
    
    // MARK: - Touch Handler Overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!  // has to be at least one touch for function!
        let location = touch.location(in: self)
        currentLine = Line(begin: location, end: location)  // inititally set to start point
        
        setNeedsDisplay()   // marks view as needing redraw
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine?.end = location
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var line = currentLine {
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            
            finishedLines.append(line)
        }
        
        currentLine = nil   // make sure to reset currentLine
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    // MARK: - Custom Stroke Functions
    
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = .round
        
        // drawing routines
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
}
