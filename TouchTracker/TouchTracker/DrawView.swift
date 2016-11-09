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
    var finishedCircles = [Circle]()
    var points = [CGPoint]()
    
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
//        // Draw finished lines in black
//        finishedLineColour.setStroke()
        
        for line in finishedLines {
            
            // silver challenge - we need to change the line colour based on its angle
            // lets divide 360.0 by 3, then increase Red, then green then blue by 1 point
            // 12, 24, 36 - 120 degrees to go from 0-1
            let angle = line.getAngleInDegrees()
            var redColour: Float = 0
            var greenColour: Float = 0
            var blueColour: Float = 0
            
            // if angle is in first quadrent, red increases
            // if in second quadrent, green increases, red decreases
            // if in third blue increases, green decreases
            
            if angle < 120.0 {
                redColour = Float((1/120.0) * angle)
            } else {
                if angle < 240.0 {
                    greenColour = Float((1/240) * angle)
                    
                    redColour = 1 - greenColour
                } else {
                    if angle < 360.0 {
                        blueColour = Float((1/360.0) * angle)
                        greenColour = 1 - blueColour
                    }
                }
            }
            
            //print("Final Colour Values: \(redColour), \(greenColour), \(blueColour)")
            
            let angleColour = UIColor(colorLiteralRed: redColour, green: greenColour, blue: blueColour, alpha: 1.0)
            
            angleColour.setStroke()
            
            strokeLine(line: line)
        }
        
        
        for (_,line) in currentLines {
            
            // make curent drawing line in red
            currentLineColour.setStroke()
            strokeLine(line: line)
            
            //print("Line Angle = \(line.getAngleInDegrees())")
        }
        
        for circle in finishedCircles {
            currentLineColour.setStroke()
            strokeCircle(circle: circle)
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
                
                // we want to draw circles when a point has not moved
                // so we work out the hypotenuse and if 0, its a point, when we have 2, its a circle!
                // using C^2 = A^2 + B^2 to find line distance
                
//                let a = (line.end.x - line.begin.x) * (line.end.x - line.begin.x)
//                let b = (line.end.y - line.begin.y) * (line.end.y - line.begin.y)
//                let c = sqrt(a + b)
                
                let hyp = hypot(line.end.x - line.begin.x, line.end.y - line.begin.y)
                
                if hyp == 0 {
                    points.append(line.begin)   // because we only have one position!
                }
                
                if points.count == 2 {
                    let circle = Circle(center: points[0], ringPoint: points[1])    // take centre/ringPoint
                    
                    finishedCircles.append(circle)
                    // reset points to capture new ones
                    points.removeAll()
                }
                
                if hyp != 0 {
                    finishedLines.append(line)
                    currentLines.removeValue(forKey: key)
                }
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
    
    func strokeCircle(circle: Circle) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        let radius = hypot(circle.ringPoint.x - circle.center.x, circle.ringPoint.y - circle.center.y)
        path.addArc(withCenter: circle.center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.stroke()
    }
}
