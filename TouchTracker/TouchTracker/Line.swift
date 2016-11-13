//
//  Line.swift
//  TouchTracker
//
//  Created by James Birchall on 09/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

struct Line {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    var velocity: CGPoint?
    var colour: UIColor?
    
    // should we have an Angle property?
    // we have begin x and y value
    // we then have end x & y value.
    
    func getAngleInDegrees() -> CGFloat {
        let angle = atan2(begin.y - end.y, begin.x - end.x)
        var degree = angle * CGFloat(180/M_PI)
        
        if degree < 0 {
            degree = degree + 360.0
        }
        
        return degree
    }
    
    func getSpeed() -> CGFloat {
        return hypot((velocity?.x)!, (velocity?.y)!) 
    }
}
