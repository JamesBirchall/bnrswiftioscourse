//
//  DrawView.swift
//  TouchTracker
//
//  Created by James Birchall on 09/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

// need gesture delegate to turn on function around being able to handle multiple gestures at same time
class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var finishedCircles = [Circle]()
    var points = [CGPoint]()
    var selectLineIndex: Int? {
        didSet {
            if self.selectLineIndex == nil {
                let menu = UIMenuController.shared
                menu.isMenuVisible = false
            }
        }
    }
    
    var currentLineSetColour: UIColor?
    
    var moveRecogniser: UIPanGestureRecognizer!
    
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
        //print(#function)
        super.init(coder: aDecoder)
        
        self.isMultipleTouchEnabled = true
        
        let doubleTapRecogniser = UITapGestureRecognizer(target: self, action: #selector(doubleTap(gestureRecogniser:)))
        doubleTapRecogniser.numberOfTapsRequired = 2
        doubleTapRecogniser.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecogniser)
        
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(tap(gestureRecogniser:)))
        tapRecogniser.delaysTouchesBegan = true
        tapRecogniser.require(toFail: doubleTapRecogniser)
        addGestureRecognizer(tapRecogniser)
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gestureRecogniser:)))
        addGestureRecognizer(longPressRecogniser)
        
        moveRecogniser = UIPanGestureRecognizer(target: self, action: #selector(moveLine(gestureRecogniser:)))
        moveRecogniser.cancelsTouchesInView = false
        moveRecogniser.delegate = self
        addGestureRecognizer(moveRecogniser)
    }
    
    // MARK: - UIView Overrides
    
    override func draw(_ rect: CGRect) {
        //print(#function)
//        // Draw finished lines in black
//        finishedLineColour.setStroke()
        
        for line in finishedLines {
            
            
            if line.colour == nil {
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
            } else {
                line.colour?.setStroke()
            }
            
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
        
        // draw selected different colour
        if let index = selectLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(line: selectedLine)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Touch Handler Overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print(#function)
        
//        let touch = touches.first!  // has to be at least one touch for function!
//        let location = touch.location(in: self)
//        currentLine = Line(begin: location, end: location)  // inititally set to start point

        if selectLineIndex == nil {
            for touch in touches {
                let location = touch.location(in: self)
                
                var newLine: Line
                
                if currentLineSetColour != nil {
                    newLine = Line(begin: location, end: location, velocity: nil, colour: currentLineSetColour)
                } else {
                    newLine = Line(begin: location, end: location, velocity: nil, colour: nil)
                }
                
                // create pointer reference and store line values
                let key = NSValue(nonretainedObject: touch)
                currentLines[key] = newLine
            }
            
            setNeedsDisplay()   // marks view as needing redraw
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print(#function)
        
//        let touch = touches.first!
//        let location = touch.location(in: self)
//        currentLine?.end = location

        if selectLineIndex == nil {
            for touch in touches {
                let key = NSValue(nonretainedObject: touch) // pull out right reference line
                currentLines[key]?.end = touch.location(in: self)   // update end point
            }
            
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print(#function)
        
//        if var line = currentLine {
//            let touch = touches.first!
//            let location = touch.location(in: self)
//            line.end = location
//            
//            finishedLines.append(line)
//        }
//        
//        currentLine = nil   // make sure to reset currentLine
        
        if selectLineIndex == nil {
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
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print(#function)
        
        currentLines.removeAll()    // get rid of any temp in progress lines
        
        setNeedsDisplay()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    
    // MARK: - Custom Stroke Functions
    
    func strokeLine(line: Line) {
        print(#function)
        let path = UIBezierPath()
        //path.lineWidth = lineThickness
        if line.velocity != nil {
            path.lineWidth = lineThickness
            //print("Line Speed: \(line.getSpeed())")
            if line.getSpeed() > 100 {
                path.lineWidth = 10
            } else if line.getSpeed() > 200 {
                path.lineWidth = 20
            } else {
                path.lineWidth = lineThickness
            }
        } else {
            path.lineWidth = lineThickness
        }
        path.lineCapStyle = .round
        
        // drawing routines
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    func strokeCircle(circle: Circle) {
        print(#function)
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        let radius = hypot(circle.ringPoint.x - circle.center.x, circle.ringPoint.y - circle.center.y)
        path.addArc(withCenter: circle.center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.stroke()
    }
    
    // MARK: - Gesture actions
    
    func doubleTap(gestureRecogniser: UIGestureRecognizer) {
        //print(#function)
        
        currentLines.removeAll()
        finishedLines.removeAll()
        finishedCircles.removeAll()
        points.removeAll()
        selectLineIndex = nil
        
        setNeedsDisplay()   // ask for redraw
    }
    
    func tap(gestureRecogniser: UIGestureRecognizer) {
        print(#function)
        
        if let selection = indexOfLineAtPoint(point: gestureRecogniser.location(in: self)) {
            selectLineIndex = selection
        } else {
            selectLineIndex = nil
        }
        
        let menu = UIMenuController.shared
        if selectLineIndex != nil {
            
            let point = gestureRecogniser.location(in: self)
            
            becomeFirstResponder()
            
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(deleteSelectedLine))
            
            menu.menuItems = [deleteItem]
            menu.setTargetRect(CGRect.init(origin: point, size: CGSize.init(width: 2, height: 2)), in: self)
            menu.isMenuVisible = true
        } else {
            menu.isMenuVisible = false
        }
        
        setNeedsDisplay()
    }
    
    func longPress(gestureRecogniser: UITapGestureRecognizer) {
        print(#function)
        
        let point = gestureRecogniser.location(in: self)
        
        if gestureRecogniser.state == .began {
            
            selectLineIndex = indexOfLineAtPoint(point: point)
            
            if selectLineIndex != nil {
                currentLines.removeAll(keepingCapacity: false)
            }
        } else if gestureRecogniser.state == .ended {
            selectLineIndex = nil
        }
        
        setNeedsDisplay()
    }
    
    // MARK: - Selection Routines
    
    func indexOfLineAtPoint(point: CGPoint) -> Int? {
        //print(#function)
        // .enumerated is a function which returns both index and item
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points on the line, 0.05 increments
            for t: CGFloat in stride(from: 0, through: 1.0, by: 0.05) {
                //print("t value is \(t)")
                
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                if hypot(x - point.x, y - point.y) < 15 {
                    return index
                }
            }
        }
        
        return nil
    }
    
    func moveLine(gestureRecogniser: UIPanGestureRecognizer) {
        print(#function)
        
        if let index = selectLineIndex {
            if gestureRecogniser.state == .changed {
                let translation = gestureRecogniser.translation(in: self)
                
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                // reset translation to keep finger in sync
                gestureRecogniser.setTranslation(.zero, in: self)
                
                finishedLines[index].velocity = gestureRecogniser.velocity(in: self)
                
                moveMenu(point: gestureRecogniser.location(in: self))
                
                setNeedsDisplay()
            }
        } else {
            print("Nothing Selected.")
        }
    }
    
    // MARK: - Menu Handlers
    
    func deleteSelectedLine() {
        //print(#function)
        finishedLines.remove(at: selectLineIndex!)
        selectLineIndex = nil
        
        setNeedsDisplay()
    }
    
    func moveMenu(point: CGPoint) {
        let menu = UIMenuController.shared
        
        if menu.isMenuVisible {
            menu.setTargetRect(CGRect(origin: point, size: CGSize.init(width: 2, height: 2)), in: self)
        }
    }
}
