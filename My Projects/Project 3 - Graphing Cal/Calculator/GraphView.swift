//
//  GraphView.swift
//  Calculator
//
//  Created by Phuc Nguyen on 7/6/15.
//  Copyright (c) 2015 m2m server software gmbh. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    //Properties
    @IBInspectable
    var scale: CGFloat = 50.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var snapshot: UIView?
    
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
            point.x = CGFloat(i) / contentScaleFactor
            if let y = dataSource?.y((point.x - origin.x) / scale) {
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
    
    func zoom(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Began:
            snapshot = self.snapshotViewAfterScreenUpdates(false)
            snapshot!.alpha = 0.8
            addSubview(snapshot!)
        case .Changed:
            let touch = gesture.locationInView(self)
            snapshot!.frame.size.height *= gesture.scale
            snapshot!.frame.size.width *= gesture.scale
            snapshot!.frame.origin.x = snapshot!.frame.origin.x * gesture.scale + ( 1 - gesture.scale) * touch.x
            snapshot!.frame.origin.y = snapshot!.frame.origin.y * gesture.scale + ( 1 - gesture.scale) * touch.y
            gesture.scale = 1.0
            
        case .Ended:
            let changedScale = snapshot!.frame.height / frame.height
            scale *= changedScale
            origin.x = origin.x * changedScale + snapshot!.frame.origin.x
            origin.y = origin.y * changedScale + snapshot!.frame.origin.y
            snapshot!.removeFromSuperview()
            snapshot = nil
        default: break
            
        }
    }
    
    func move(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            snapshot = snapshotViewAfterScreenUpdates(false)
            snapshot!.alpha = 0.8
            addSubview(snapshot!)
        case .Ended:
            fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            snapshot!.center.x += translation.x
            snapshot!.center.y += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        case .Ended:
            origin.x += snapshot!.frame.origin.x
            origin.y += snapshot!.frame.origin.y
            snapshot!.removeFromSuperview()
            snapshot = nil
        default:
            break
        }
    }
    
    func center(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            origin = gesture.locationInView(self)
        }
    }
    
    

}

protocol GraphViewDataSource: class {
    func y(x: CGFloat) -> CGFloat?
}
