//
//  GraphView.swift
//  Calculator
//
//  Created by Phuc Nguyen on 7/6/15.
//  Copyright (c) 2015 m2m server software gmbh. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    //Properties
    var scale: CGFloat = 50.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var origin = CGPoint() {
        didSet {
            resetOrigin = false
            setNeedsDisplay()
        }
    }
    
    private var resetOrigin: Bool = true {
        didSet{
            if resetOrigin {
                setNeedsDisplay()
            }
        }
    }
    
    weak var dataSource: GraphViewController?
    
    var lineWidth: CGFloat = 1.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var color: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //Functions
    override func drawRect(rect: CGRect) {
        if resetOrigin {
            origin = center
        }
        AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        
        color.set()
        let path = UIBezierPath()
        var firstValue = true
        var point = CGPoint()
        
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor);i++ {
            point.x = CGFloat(I) / contentScaleFactor
            if let y = dataSource.y(point.x - origin.x) / scale {
                if !y.isNormal && !y.isZero {
                    continue
                }
                point.y = origin.y - y * scale
                if firstValue {
                    path.moveToPoint(point)
                    firstValue = false
                } else {
                    path.addLineToPoint(point)
                }
            }
        }
        
        path.stroke()
    }

}

protocol GraphViewDataSource: class {
    func y(x: CGFloat) -> CGFloat?
}
